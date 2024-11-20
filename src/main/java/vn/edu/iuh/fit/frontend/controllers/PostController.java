package vn.edu.iuh.fit.frontend.controllers;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import vn.edu.iuh.fit.backend.models.Post;
import vn.edu.iuh.fit.backend.models.User;
import vn.edu.iuh.fit.backend.services.PostService;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Controller
@RequestMapping("/posts")
public class PostController {
    @Autowired
    private PostService postService;

    @GetMapping("/list")
    public String getAllPosts(Model model, @RequestParam("page") Optional<Integer> page, @RequestParam("size") Optional<Integer> size) {
        int pageNo = page.orElse(1);
        int pageSize = size.orElse(10);
        Page<Post> posts = postService.findAll(pageNo -1 , pageSize, "id", "asc");
        model.addAttribute("posts", posts);

        int totalPages = posts.getTotalPages();
        if (totalPages > 0) {
            List<Integer> pageNumbers = IntStream.rangeClosed(1, totalPages)
                    .boxed()
                    .collect(Collectors.toList());
            model.addAttribute("pageNumbers", pageNumbers);
        }
        return "post/list";
    }


    @GetMapping("/show_add_form")
    public ModelAndView showAddForm() {
        ModelAndView modelAndView = new ModelAndView("post/addPost");
        modelAndView.addObject("post", new Post());
        return modelAndView;
    }

    @PostMapping("/add")
    public String addPost(@ModelAttribute("post") Post post, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        post.setAuthor(user);
        if(post.getPublished()) {
            post.publish();
        }
        postService.save(post);
        return "redirect:/users/home";
    }

    @GetMapping("/show_update_form/{id}")
    public ModelAndView showUpdateForm(@PathVariable("id") Long id) {
        ModelAndView modelAndView = new ModelAndView("post/updatePost");
        Post post = postService.findById(id).orElseThrow(() -> new IllegalArgumentException("Invalid post Id:" + id));
        modelAndView.addObject("postId", id);
        modelAndView.addObject("post", post);

        return modelAndView;
    }

    @PostMapping("/update/{id}")
    public String updatePost(@PathVariable("id") Long id, @ModelAttribute("post") Post post) {
        Post postToUpdate = postService.findById(id).orElseThrow(() -> new IllegalArgumentException("Invalid post Id:" + id));
        postToUpdate.setTitle(post.getTitle());
        postToUpdate.setTitle(post.getMetaTitle());
        postToUpdate.setSummary(post.getSummary());
        postToUpdate.setContent(post.getContent());
        if(post.getPublished()) {
            postToUpdate.setPublished(true);
            postToUpdate.publish();
        }

        postService.save(postToUpdate);
        return "redirect:/users/home";
    }

    @PostMapping("/delete/{id}")
    public String deletePost(@PathVariable("id") Long id) {
        postService.deleteById(id);
        return "redirect:/users/home";
    }

}