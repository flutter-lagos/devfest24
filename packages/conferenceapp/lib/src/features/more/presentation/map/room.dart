enum RoomType {
  entranceHallway,
  exhibitionRoom,
  room1,
  room2,
  room3,
  networkZone,
  hallway,
  restroom,
  stairs,
  room4,
  greenRoom;

  const RoomType();

  @override
  String toString() => switch (this) {
        RoomType.exhibitionRoom => 'Exhibition Room',
        RoomType.room1 => 'Room 1',
        RoomType.room2 => 'Room 2',
        RoomType.hallway => 'Hallway',
        RoomType.restroom => 'Restroom',
        RoomType.stairs => 'Stairs',
        RoomType.room3 => 'Room 3',
        RoomType.room4 => 'Room 4',
        RoomType.entranceHallway => 'Entrance Hallway',
        RoomType.networkZone => 'Network Zone',
        RoomType.greenRoom => 'Green Room',
      };
}
