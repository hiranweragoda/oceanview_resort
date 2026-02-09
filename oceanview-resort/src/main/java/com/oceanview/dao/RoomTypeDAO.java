package com.oceanview.dao;

import com.oceanview.model.RoomType;
import java.util.List;

public interface RoomTypeDAO {

    List<RoomType> getAllRoomTypes();

    RoomType getRoomTypeById(int id);

    // Added these three methods to match what your servlet is calling
    boolean addRoomType(RoomType roomType);

    boolean updateRoomType(RoomType roomType);

    boolean deleteRoomType(int id);
}