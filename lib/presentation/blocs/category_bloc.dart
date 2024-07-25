import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visionapp/core/generics/no_params.dart';
import 'package:visionapp/domain/entities/category.dart';
import 'package:visionapp/domain/usecases/home/category/list_category.dart';

@immutable
sealed class CategoryState {}
//State
final class CategoryInitial extends CategoryState{}
final class CategoryLoading extends CategoryState{}
final class CategoryError extends CategoryState {
  final String message;
  CategoryError({required this.message});
}
final class CategoryListFetched extends CategoryState{
  final List<Category> categories;
  CategoryListFetched({required this.categories});
}
//Event
@immutable
sealed class CategoryEvent {}

class FetchCategory extends CategoryEvent{}


class CategoryBloc extends Bloc<CategoryEvent,CategoryState> {
  final ListCategory _listCategory;

  CategoryBloc({required ListCategory listCategory}):
        _listCategory = listCategory,
        super(CategoryInitial()) {

     on<CategoryEvent>((_, emit) => emit(CategoryLoading()));
     on<FetchCategory>(_fetchCategory);
  }

  _fetchCategory(FetchCategory event, Emitter<CategoryState> emit) async {
    final  result = await _listCategory.call(NoParams());
    result.fold(
          (failure) => emit(CategoryError( message: failure.message)),
          (categories) => emit(CategoryListFetched(categories: categories)),
    );
  }
}
