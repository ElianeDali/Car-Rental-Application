import 'package:get_it/get_it.dart';
import 'package:rentapp/data/datasources/api_car_data_source.dart';
import 'package:rentapp/data/repositories/car_repository_impl.dart';
import 'package:rentapp/domain/repositories/car_repository.dart';
import 'package:rentapp/domain/usecases/get_cars.dart';
import 'package:rentapp/presentation/bloc/car_bloc.dart';

GetIt getIt = GetIt.instance;

void initInjection(){
  try{
    // Register API data source (replaces Firebase)
    getIt.registerLazySingleton<ApiCarDataSource>(
      () => ApiCarDataSource()
    );
    
    getIt.registerLazySingleton<CarRepository>(
      () => CarRepositoryImpl(getIt<ApiCarDataSource>())
    );
    
    getIt.registerLazySingleton<GetCars>(
      () => GetCars(getIt<CarRepository>())
    );
    
    getIt.registerFactory(() => CarBloc(getCars: getIt<GetCars>()));

  } catch (e){
    rethrow;
  }
}
