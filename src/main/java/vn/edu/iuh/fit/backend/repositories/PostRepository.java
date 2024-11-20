package vn.edu.iuh.fit.backend.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import vn.edu.iuh.fit.backend.models.Post;

public interface PostRepository extends JpaRepository<Post, Long> {
}