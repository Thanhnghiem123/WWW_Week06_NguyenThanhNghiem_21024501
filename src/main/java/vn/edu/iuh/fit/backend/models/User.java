package vn.edu.iuh.fit.backend.models;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.Instant;
import java.util.LinkedHashSet;
import java.util.Set;

@Getter
@Setter
@Entity
@Table(name = "user")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @Size(max = 50)
    @Column(name = "first_name", length = 50)
    private String firstName;

    @Size(max = 50)
    @Column(name = "middle_Name", length = 50)
    private String middleName;

    @Size(max = 50)
    @Column(name = "last_name", length = 50)
    private String lastName;

    @Size(max = 15)
    @Column(name = "mobile", length = 15)
    private String mobile;

    @Size(max = 50)
    @Column(name = "email", length = 50)
    private String email;

    @Size(max = 255)
    @NotNull
    @Column(name = "password_hash", nullable = false, length = 32)
    private String passwordHash;

    @NotNull
    @CreationTimestamp
    @Column(name = "registered_at", nullable = false, updatable = false)
    private Instant registeredAt = Instant.now();

    @Column(name = "last_login")
    @UpdateTimestamp
    private Instant lastLogin;

    @Lob
    @Column(name = "intro")
    private String intro;

    @Lob
    @Column(name = "profile")
    private String profile;

    @OneToMany(mappedBy = "author")
    private Set<Post> posts = new LinkedHashSet<>();

    @OneToMany(mappedBy = "user")
    private Set<PostComment> postComments = new LinkedHashSet<>();

}