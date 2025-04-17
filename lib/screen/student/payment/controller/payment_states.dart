class PaymentStates{}

class PaymentInitialState extends PaymentStates{}


class LoadingPaymentState extends PaymentStates{}
class SuccessPaymentState extends PaymentStates{}
class ErrorPaymentState extends PaymentStates{
  final String msg;
  ErrorPaymentState({required this.msg});
}
