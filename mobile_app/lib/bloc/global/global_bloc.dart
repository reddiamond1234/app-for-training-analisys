import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/firestore_users_service.dart';
import '../../services/local_storage_service.dart';
import '../../util/either.dart';
import '../../util/failures/auth_failure.dart';
import '../../util/failures/failure.dart';

part 'global_event.dart';
part 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  final FirebaseAuthService _firebaseAuthService;
  final FirestoreUsersService _usersService = FirestoreUsersService();

  final StreamController<int> _selectedHomeTabController =
      StreamController.broadcast();
  final StreamController<int> _selectedHomeTobBarController =
      StreamController.broadcast();

  final LocalStorageService _localStorageService;

  Stream<int> get selectedHomeTabStream => _selectedHomeTabController.stream;
  Stream<int> get selectedHomeTobBarStream =>
      _selectedHomeTobBarController.stream;

  StreamSubscription? _userStreamSubscription;

  final GlobalKey<NavigatorState> navigatorKey;
  GlobalBloc({
    required FirebaseAuthService firebaseAuthService,
    required LocalStorageService localStorageService,
    required this.navigatorKey,
  })  : _firebaseAuthService = firebaseAuthService,
        _localStorageService = localStorageService,
        super(const GlobalState.initial()) {
    on<_InitializeEvent>(_onInitialize);
    on<_SignOutEvent>(_onSignOut);
    on<_UsersChanged>(_onUsersChanged);

    on<_UpdateUserEvent>(_onUpdateUser);
  }

  @override
  Future<void> close() async {
    _selectedHomeTabController.close();
    _selectedHomeTobBarController.close();
    return super.close();
  }

  // PUBLIC API

  void setSelectedHomeTab(int index) => _selectedHomeTabController.add(index);

  String? get userId =>
      state.user?.id ?? _firebaseAuthService.getCurrentUser()?.uid;

  BVUser? getUser(String? userId) {
    return state.users?.firstWhereOrNull((user) => user.id == userId);
  }

  void signOut() => add(const _SignOutEvent());
  void updateUser(BVUser user) => add(_UpdateUserEvent(user));

  Future<Either<Failure, void>> initialize() async {
    final User? user;
    try {
      user = _firebaseAuthService.getCurrentUser();

      if (user == null) {
        return error(const NotLoggedInFailure());
      }

      final Either<Failure, BVUser?> currentUserOrFailure =
          await _usersService.getItem(user.uid);

      if (currentUserOrFailure.isError()) {
        return error(const UserInformationFetchFailure());
      }

      _userStreamSubscription =
          _usersService.userStream(currentUserOrFailure.value!.id).listen(
        (event) async {
          if (isClosed) {
            await _userStreamSubscription?.cancel();
            return;
          }
          add(_UpdateUserEvent(event.data()!));
        },
      );

      add(_InitializeEvent(
        user: currentUserOrFailure.value!,
      ));

      return value(null);
    } catch (_) {
      return error(const NotLoggedInFailure());
    }
  }

  FutureOr<void> _onUpdateUser(
    _UpdateUserEvent event,
    Emitter<GlobalState> emit,
  ) {
    emit(state.copyWith(user: event.user));
  }

  Future<Either<Failure, void>> deleteAccount() async {
    final User? user = _firebaseAuthService.getCurrentUser();
    try {
      if (user == null) {
        return error(const NotLoggedInFailure());
      }

      await _usersService.updateDocumentData(
        id: user.uid,
        data: {"deleted": true},
      );

      final Either<Failure, void> voidOrFailure =
          await _firebaseAuthService.deleteAccount();

      if (voidOrFailure.isError()) {
        await _usersService.updateDocumentData(
          id: user.uid,
          data: {"deleted": false, "reasonForLeaving": null},
        );

        return error(voidOrFailure.error);
      }
      signOut();
      return value(null);
    } catch (_) {
      return error(const UnknownAuthFailure());
    }
  }

  // HANDLERS

  FutureOr<void> _onInitialize(
    _InitializeEvent event,
    Emitter<GlobalState> emit,
  ) async {
    emit(state.copyWith(user: event.user));
  }

  FutureOr<void> _onSignOut(
    _SignOutEvent event,
    Emitter<GlobalState> emit,
  ) async {
    await _userStreamSubscription?.cancel();
    emit(const GlobalState.initial());
    await _firebaseAuthService.signOut();
    await _localStorageService.deleteAuthProvider();
  }

  FutureOr<void> _onUsersChanged(
    _UsersChanged event,
    Emitter<GlobalState> emit,
  ) {
    final List<BVUser> users = [];

    event.users
        .map((element) => element != null ? users.add(element) : null)
        .toList();
    emit(state.copyWith(users: users));
  }
}
