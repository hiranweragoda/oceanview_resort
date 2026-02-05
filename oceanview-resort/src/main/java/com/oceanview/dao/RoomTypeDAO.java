package com.oceanview.dao;

import com.oceanview.model.RoomType;
import java.util.List;

public interface RoomTypeDAO {
    void addRoomType(RoomType roomType);
    RoomType getRoomTypeById(int id);
    RoomType getRoomTypeByName(String typeName);
    List<RoomType> getAllRoomTypes();
    boolean updateRoomType(RoomType roomType);
    boolean deleteRoomType(int id);
}