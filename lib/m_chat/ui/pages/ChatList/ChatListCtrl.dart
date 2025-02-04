import 'package:odc_mobile_project/m_chat/business/interactor/chatInteractor.dart';
import 'package:odc_mobile_project/m_chat/ui/pages/ChatList/ChatListState.dart';
import 'package:odc_mobile_project/m_user/business/interactor/UserInteractor.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:odc_mobile_project/m_chat/business/model/ChatUsersModel.dart';

part "ChatListCtrl.g.dart";

@riverpod
class ChatListCtrl extends _$ChatListCtrl {
  @override
  ChatListState build() {
    getUser();
    return ChatListState();
  }

  void getUser()async{
    var usecase = ref.watch(userInteractorProvider).getUserLocalUseCase;
    var res=await usecase.run();
    state = state.copyWith(auth: res);
  }

  Future<String> getToken() async{
    var usecase =  ref.watch(userInteractorProvider).getTokenUseCase;
    var res = await usecase.run();
    return Future.value(res);
  }

  void getList() async {
    state = state.copyWith(isLoading: true, chatsUsers: List.empty());
    getUser();
    var token = await getToken(); 
    var interactor = ref.watch(chatInteractorProvider);
    var res = await interactor.recupererListMessageGroupeUseCase.run(token);
    state = state.copyWith(isLoading: false, chatsUsers: res);
  }
}