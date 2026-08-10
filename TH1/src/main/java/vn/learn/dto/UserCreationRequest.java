package vn.learn.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserCreationRequest {
    private String username;
    private String email;
    private String password;
}