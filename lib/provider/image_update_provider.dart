import 'package:flutter/cupertino.dart';
import 'package:videocalling/Enum/view_state.dart';

class ImageUpdateProvider with ChangeNotifier{

  ViewState _viewState = ViewState.IDLE;
  ViewState get getViewState => _viewState;


  void setToLoading(){
    _viewState = ViewState.LOADING;
    notifyListeners();

  }

  void setToIdle(){
    _viewState = ViewState.IDLE;
    notifyListeners();
  }


}