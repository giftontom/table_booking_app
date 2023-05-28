import 'package:intl/intl.dart';

class HotelListData {
  String imagePath;
  String titleTxt;
  String subTxt;
  String dateTxt;
  String roomSizeTxt;
  double dist;
  double rating;
  int reviews;
  int perNight;
  bool isSelected;

  HotelListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.subTxt = "",
    this.dateTxt = "",
    this.roomSizeTxt = "",
    this.dist = 1.8,
    this.reviews = 80,
    this.rating = 4.5,
    this.perNight = 180,
    this.isSelected = false,
  });

  static List<HotelListData> hotelList = [
    HotelListData(
      imagePath: 'assets/images/order.png',
      titleTxt: 'Grand Royal Hotel',
      subTxt: 'Wembley, London',
      dist: 2.0,
      reviews: 80,
      rating: 4.4,
      perNight: 180,
      roomSizeTxt: '1 Room - 2 Adults',
      isSelected: true,
      dateTxt:
          '${DateFormat("dd MMM").format(DateTime.now().add(Duration(days: 2)))} - ${DateFormat("dd MMM").format(DateTime.now().add(Duration(days: 8)))}',
    ),
  ];

  static List<HotelListData> popularList = [
    HotelListData(
      imagePath: 'assets/images/popular_1.jpg',
      titleTxt: 'Paris',
    ),
    HotelListData(
      imagePath: 'assets/images/popular_2.jpg',
      titleTxt: 'Spain',
    ),
    HotelListData(
      imagePath: 'assets/images/popular_3.jpg',
      titleTxt: 'Vernazza',
    ),
    HotelListData(
      imagePath: 'assets/images/popular_4.jpg',
      titleTxt: 'London',
    ),
    HotelListData(
      imagePath: 'assets/images/popular_5.jpg',
      titleTxt: 'Venice',
    ),
    HotelListData(
      imagePath: 'assets/images/popular_6.jpg',
      titleTxt: 'Diamond Head',
    ),
  ];

  static List<HotelListData> reviewsList = [
    HotelListData(
      imagePath: 'assets/images/avatar1.jpg',
      titleTxt: 'Alexia Jane',
      subTxt:
          'This is located in a great spot close to shops and bars, very quiet location',
      rating: 8.0,
      dateTxt: 'Last update 21 May, 2019',
    ),
    HotelListData(
      imagePath: 'assets/images/avatar3.jpg',
      titleTxt: 'Jacky Depp',
      subTxt:
          'Good staff, very comfortable bed, very quiet location, place could do with an update',
      rating: 8.0,
      dateTxt: 'Last update 21 May, 2019',
    ),
    HotelListData(
      imagePath: 'assets/images/avatar5.jpg',
      titleTxt: 'Alex Carl',
      subTxt:
          'This is located in a great spot close to shops and bars, very quiet location',
      rating: 6.0,
      dateTxt: 'Last update 21 May, 2019',
    ),
    HotelListData(
      imagePath: 'assets/images/avatar2.jpg',
      titleTxt: 'May June',
      subTxt:
          'Good staff, very comfortable bed, very quiet location, place could do with an update',
      rating: 9.0,
      dateTxt: 'Last update 21 May, 2019',
    ),
    HotelListData(
      imagePath: 'assets/images/avatar4.jpg',
      titleTxt: 'Lesley Rivas',
      subTxt:
          'This is located in a great spot close to shops and bars, very quiet location',
      rating: 8.0,
      dateTxt: 'Last update 21 May, 2019',
    ),
    HotelListData(
      imagePath: 'assets/images/avatar6.jpg',
      titleTxt: 'Carlos Lasmar',
      subTxt:
          'Good staff, very comfortable bed, very quiet location, place could do with an update',
      rating: 7.0,
      dateTxt: 'Last update 21 May, 2019',
    ),
    HotelListData(
      imagePath: 'assets/images/avatar7.jpg',
      titleTxt: 'Oliver Smith',
      subTxt:
          'This is located in a great spot close to shops and bars, very quiet location',
      rating: 9.0,
      dateTxt: 'Last update 21 May, 2019',
    ),
  ];

  static List<HotelListData> romeList = [
    HotelListData(
      imagePath:
          'assets/images/room_1.jpg assets/images/room_2.jpg assets/images/room_3.jpg',
      titleTxt: 'Deluxe Room',
      perNight: 180,
      dateTxt: 'Sleeps 3 people',
    ),
    HotelListData(
      imagePath:
          'assets/images/room_4.jpg assets/images/room_5.jpg assets/images/room_6.jpg',
      titleTxt: 'Premium Room',
      perNight: 200,
      dateTxt: 'Sleeps 3 people + 2 children',
    ),
    HotelListData(
      imagePath:
          'assets/images/room_7.jpg assets/images/room_8.jpg assets/images/room_9.jpg',
      titleTxt: 'Queen Room',
      perNight: 240,
      dateTxt: 'Sleeps 4 people + 4 children',
    ),
    HotelListData(
      imagePath:
          'assets/images/room_10.jpg assets/images/room_11.jpg assets/images/room_12.jpg',
      titleTxt: 'King Room',
      perNight: 240,
      dateTxt: 'Sleeps 4 people + 4 children',
    ),
    HotelListData(
      imagePath:
          'assets/images/room_11.jpg assets/images/room_1.jpg assets/images/room_2.jpg',
      titleTxt: 'Hollywood Twin Room',
      perNight: 260,
      dateTxt: 'Sleeps 4 people + 4 children',
    ),
  ];

  static List<HotelListData> hotelTypeList = [
    HotelListData(
      imagePath: 'assets/images/hotel_Type_1.jpg',
      titleTxt: 'Hotels',
      isSelected: false,
    ),
    HotelListData(
      imagePath: 'assets/images/hotel_Type_2.jpg',
      titleTxt: 'Backpacker',
      isSelected: false,
    ),
    HotelListData(
      imagePath: 'assets/images/hotel_Type_3.jpg',
      titleTxt: 'Resort',
      isSelected: false,
    ),
    HotelListData(
      imagePath: 'assets/images/hotel_Type_4.jpg',
      titleTxt: 'Villa',
      isSelected: false,
    ),
    HotelListData(
      imagePath: 'assets/images/hotel_Type_5.jpg',
      titleTxt: 'Apartment',
      isSelected: false,
    ),
    HotelListData(
      imagePath: 'assets/images/hotel_Type_6.jpg',
      titleTxt: 'Guest house',
      isSelected: false,
    ),
    HotelListData(
      imagePath: 'assets/images/hotel_Type_7.jpg',
      titleTxt: 'Motel',
      isSelected: false,
    ),
    HotelListData(
      imagePath: 'assets/images/hotel_Type_8.jpg',
      titleTxt: 'Accommodation',
      isSelected: false,
    ),
    HotelListData(
      imagePath: 'assets/images/hotel_Type_9.jpg',
      titleTxt: 'Bed & breakfast',
      isSelected: false,
    ),
  ];
  static List<HotelListData> lastsSearchesList = [
    HotelListData(
      imagePath: 'assets/images/popular_4.jpg',
      titleTxt: 'London',
      subTxt: '1 Room - 2 Adults',
      dateTxt: '12 - 22 Dec',
    ),
    HotelListData(
      imagePath: 'assets/images/popular_1.jpg',
      titleTxt: 'Paris',
      subTxt: '2 Room - 4 Adults',
      dateTxt: '12 - 24 Sep',
    ),
    HotelListData(
      imagePath: 'assets/images/city_3.jpg',
      titleTxt: 'New York',
      subTxt: '1 Room - 3 Adults',
      dateTxt: '20 - 22 Sep',
    ),
    HotelListData(
      imagePath: 'assets/images/city_4.jpg',
      titleTxt: 'Tokyo',
      subTxt: '1 Room - 2 Adults',
      dateTxt: '12 - 22 Nov',
    ),
    HotelListData(
      imagePath: 'assets/images/city_5.jpg',
      titleTxt: 'Shanghai',
      subTxt: '2 Room - 4 Adults',
      dateTxt: '10 - 15 Dec',
    ),
    HotelListData(
      imagePath: 'assets/images/city_6.jpg',
      titleTxt: 'Moscow',
      subTxt: '5 Room - 10 Adults',
      dateTxt: '12 - 14 Dec',
    ),
  ];
}
