import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_mania_admin/dio/repository.dart';

import '../../../data/respository/registerDeviceRepository.dart';

part 'deviceregistration_state.dart';

class DeviceregistrationCubit extends Cubit<DeviceregistrationState> {
  DeviceregistrationCubit({required this.registerDeviceRepository})
      : super(DeviceregistrationInitial());

  final RegisterDeviceRepository registerDeviceRepository;

  registerDevice(registrationToken) async {
    var registrationStatus =
        await Repository().registerDevice(registrationToken);
  }
}
