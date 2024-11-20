package vn.edu.iuh.fit.backend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import vn.edu.iuh.fit.backend.models.PostComment;
import vn.edu.iuh.fit.backend.repositories.PostCommentRepository;

import java.util.List;
import java.util.Optional;

@Service
public class PostCommentService {
    @Autowired
    private PostCommentRepository postCommentRepository;

    public Page<PostComment> findAll(int pageNo, int pageSize, String sortBy, String sortDirection) {
        Sort sort = Sort.by(Sort.Direction.fromString(sortDirection), sortBy);
        PageRequest pageable = PageRequest.of(pageNo, pageSize, sort);
        return postCommentRepository.findAll(pageable);
    }

    public Optional<PostComment> findById(Long id) {
        return postCommentRepository.findById(id);
    }

    public PostComment save(PostComment postComment) {
        return postCommentRepository.save(postComment);
    }

    public void deleteById(Long id) {
        postCommentRepository.deleteById(id);
    }

    public Page<PostComment> findByPostId(Long postId, int pageNo, int pageSize, String sortBy, String sortDirection) {
        Sort sort = Sort.by(Sort.Direction.fromString(sortDirection), sortBy);
        PageRequest pageable = PageRequest.of(pageNo, pageSize, sort);
        return postCommentRepository.findByPostId(postId, pageable);
    }
}