package vn.edu.iuh.fit.frontend.controllers;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import vn.edu.iuh.fit.backend.models.Post;
import vn.edu.iuh.fit.backend.models.PostComment;
import vn.edu.iuh.fit.backend.models.User;
import vn.edu.iuh.fit.backend.services.PostCommentService;
import vn.edu.iuh.fit.backend.services.PostService;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Controller
@RequestMapping("/comments")
public class PostCommentController {
    @Autowired
    private PostCommentService postCommentService;

    @Autowired
    private PostService postService;

    // Get list of comments by post id
    @GetMapping("/list/{id}")
    public String getAllComments(@PathVariable("id") Long id, Model model, @RequestParam("page") Optional<Integer> page, @RequestParam("size") Optional<Integer> size, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");

        int pageNo = page.orElse(1);
        int pageSize = size.orElse(10);

        Page<PostComment> postsComments = postCommentService.findByPostId(id, pageNo - 1, pageSize, "createdAt", "desc");
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("postComments", postsComments);
        model.addAttribute("postId", id);
        if (!postsComments.isEmpty()) {
            model.addAttribute("postTitle", postsComments.getContent().get(0).getPost().getTitle());
        } else {
            model.addAttribute("postTitle", "No comments found for this post.");
        }
        // Thêm đối tượng postComment vào model
        PostComment postComment = new PostComment();
        postComment.setPost(new Post());
        postComment.getPost().setId(id);
        model.addAttribute("postComment", postComment);

        int totalPages = postsComments.getTotalPages();
        if (totalPages > 0) {
            List<Integer> pageNumbers = IntStream.rangeClosed(1, totalPages)
                    .boxed()
                    .collect(Collectors.toList());
            model.addAttribute("pageNumbers", pageNumbers);
        }
        return "postcomment/list";
    }


    @PostMapping("/add/{id}")
    public String addPostComment(@PathVariable("id") Long id, @ModelAttribute("postComment") PostComment postComment, HttpSession session, Model model, BindingResult result) {
        User currentUser = (User) session.getAttribute("currentUser");

        model.addAttribute("postId", id);
//        postComment.setCreatedAt(Instant.now());
        postComment.setUser(currentUser);
        postComment.setPost(postService.findById(id).orElseThrow(() -> new IllegalArgumentException("Invalid post Id:" + id)));

        postComment.setPublished(true);
        postComment.publish();
        // Ensure the id is not set to avoid updating an existing comment
        postComment.setId(null);

        postCommentService.save(postComment);
        return "redirect:/comments/list/" + id;
    }

    // show update form for comment by comment id
    @GetMapping("/show_update_form/{id}")
    public ModelAndView showUpdateForm(@PathVariable("id") Long id) {
        ModelAndView modelAndView = new ModelAndView("postcomment/updateComment");
        PostComment postComment = postCommentService.findById(id).orElseThrow(() -> new IllegalArgumentException("Invalid comment Id:" + id));
        modelAndView.addObject("commentId", id);
        modelAndView.addObject("postComment", postComment);
        return modelAndView;
    }

    @PostMapping("/update/{id}")
    public String updatePostComment(@PathVariable("id") Long id, @ModelAttribute("postComment") PostComment postComment, BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("postComment", postComment);
            return "postcomment/updateComment";
        }

        PostComment existingComment = postCommentService.findById(id).orElseThrow(() -> new IllegalArgumentException("Invalid comment Id:" + id));
        ;
        if (existingComment == null) {
            result.rejectValue("id", "error.postComment", "Comment not found");
            return "postcomment/updateComment";
        }

        existingComment.setTitle(postComment.getTitle());
        existingComment.setContent(postComment.getContent());
        existingComment.setPost(postComment.getPost() != null ? postComment.getPost() : existingComment.getPost());
        if (postComment.getPublished()) {
            existingComment.setPublished(true);
            existingComment.publish();
        } else {
            existingComment.setPublished(false);
        }
        postCommentService.save(existingComment);
        return "redirect:/comments/list/" + existingComment.getPost().getId();
    }

    // delete comment
    @PostMapping("/delete/{id}")
    public String deletePostComment(@PathVariable("id") Long id) {
        PostComment postComment = postCommentService.findById(id).orElseThrow(() -> new IllegalArgumentException("Invalid comment Id:" + id));
        postCommentService.deleteById(postComment.getId());
        return "redirect:/comments/list/" + postComment.getPost().getId();
    }

}