package vn.learn.service;

import vn.learn.dto.UserCreationRequest;
import vn.learn.dto.UserResponse;

public interface UserService {
    UserResponse createUser(UserCreationRequest request);
}