import 'package:coin_market_app/features/home/presentation/bloc/home_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeEvent', () {
    group('GetAllExchangesEvent', () {
      test('should be equal when instances are the same', () {
        const event1 = GetAllExchangesEvent();
        const event2 = GetAllExchangesEvent();

        expect(event1, equals(event2));
      });

      test('should have correct hash code', () {
        const event1 = GetAllExchangesEvent();
        const event2 = GetAllExchangesEvent();

        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('should have correct string representation', () {
        const event = GetAllExchangesEvent();
        expect(event.toString(), equals('GetAllExchangesEvent()'));
      });

      test('should be instance of GetAllExchangesEvent', () {
        const event = GetAllExchangesEvent();
        expect(event, isA<GetAllExchangesEvent>());
      });

      test('should be instance of HomeEvent', () {
        const event = GetAllExchangesEvent();
        expect(event, isA<HomeEvent>());
      });

      test('should extend HomeEvent', () {
        const event = GetAllExchangesEvent();
        expect(event, isA<HomeEvent>());
      });

      test('should have empty props list', () {
        const event = GetAllExchangesEvent();
        expect(event.props, isEmpty);
      });

      test('should be const constructible', () {
        const event = GetAllExchangesEvent();
        expect(event, isA<GetAllExchangesEvent>());
      });
    });

    test('should have correct inheritance', () {
      const event = GetAllExchangesEvent();
      expect(event, isA<HomeEvent>());
      expect(event, isA<GetAllExchangesEvent>());
    });

    test('should be immutable', () {
      const event1 = GetAllExchangesEvent();
      const event2 = GetAllExchangesEvent();

      expect(event1, equals(event2));
      expect(event1.hashCode, equals(event2.hashCode));
    });
  });
}
