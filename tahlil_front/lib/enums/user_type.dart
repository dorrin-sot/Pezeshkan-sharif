enum UserType {
  patient,
  doctor,
  referrer;

  @override
  String toString() {
    switch(this) {
      case UserType.patient: return 'Patient';
      case UserType.doctor: return 'Doctor';
      case UserType.referrer: return 'Referrer';
    }
  }
}
