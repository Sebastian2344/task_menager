import 'package:flutter_test/flutter_test.dart';
import 'package:task_meneger/modules/page_module/providers/page_provider.dart';

void main(){

  late PageProvider pageProvider;

  setUp((){
    pageProvider = PageProvider();
  });

  test('PageProvider zmana stron', (){
    int notifications = 0;
     pageProvider.addListener(() {
      notifications++;
    });
    expect(pageProvider.currentPage, 0);
    expect(notifications, 0);

    pageProvider.setCurrentPage(1);
    expect(pageProvider.currentPage, 1);
    expect(notifications, 1);

    pageProvider.setCurrentPage(2);
    expect(pageProvider.currentPage, 2);
    expect(notifications, 2);

    pageProvider.setCurrentPage(2); // No change
    expect(pageProvider.currentPage, 2);
    expect(notifications, 2); // No new notification

    pageProvider.setCurrentPage(0);
    expect(pageProvider.currentPage, 0);
    expect(notifications, 3);
  });
}