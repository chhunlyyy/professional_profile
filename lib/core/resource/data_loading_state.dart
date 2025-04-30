import 'package:dio/dio.dart';

abstract class DataState<T> {
  final T? data;
  final DioException? error;

  const DataState({this.data, this.error});
}

class DataLoading<T> extends DataState<T> {
  const DataLoading();
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T? datas) : super(data: datas);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(DioException error) : super(error: error);
}
