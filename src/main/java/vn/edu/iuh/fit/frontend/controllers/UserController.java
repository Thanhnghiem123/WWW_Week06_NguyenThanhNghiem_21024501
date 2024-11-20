package vn.edu.iuh.fit.frontend.controllers;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import vn.edu.iuh.fit.backend.models.Post;
import vn.edu.iuh.fit.backend.models.User;
import vn.edu.iuh.fit.backend.services.PostService;
import vn.edu.iuh.fit.backend.services.UserService;

import java.security.Principal;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Controller
@RequestMapping("/users")
public class UserController {
    @Autowired
    private UserService userService;

    @Autowired
    private PostService postService;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;


    @GetMapping("/list")
    public String getAllUsers(Model model, @RequestParam("page") Optional<Integer> page, @RequestParam("size") Optional<Integer> size) {
        int pageNo = page.orElse(1);
        int pageSize = size.orElse(10);
        Page<User> users = userService.findAll(pageNo - 1, pageSize, "id", "asc");
        model.addAttribute("users", users);

        int totalPages = users.getTotalPages();
        if (totalPages > 0) {
            List<Integer> pageNumbers = IntStream.rangeClosed(1, totalPages)
                    .boxed()
                    .collect(Collectors.toList());
            model.addAttribute("pageNumbers", pageNumbers);
        }
        return "user/list";
    }

    @GetMapping("/home")
    public String home(Model model,
                       @RequestParam("page") Optional<Integer> page,
                       @RequestParam("size") Optional<Integer> size, HttpSession session) {
        int pageNo = page.orElse(1);
        int pageSize = size.orElse(10);

        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/users/show_signin_form";
        }
        model.addAttribute("user", user);

        Page<Post> posts = postService.findAll(pageNo - 1, pageSize, "createdAt", "desc");
        model.addAttribute("posts", posts);

        int totalPages = posts.getTotalPages();
        if (totalPages > 0) {
            List<Integer> pageNumbers = IntStream.rangeClosed(1, totalPages)
                    .boxed()
                    .collect(Collectors.toList());
            model.addAttribute("pageNumbers", pageNumbers);
        }
        return "user/home";
    }


    @GetMapping("/show_add_form")
    public ModelAndView showAddForm() {
        ModelAndView mav = new ModelAndView();
        User user = new User();
        mav.addObject("user", user);
        mav.setViewName("user/addUser");
        return mav;
    }

    @PostMapping("/addUser")
    public String addUser(@ModelAttribute("user") User user) {
        user.setPasswordHash(userService.setPasswordHash(user.getPasswordHash()));
        userService.save(user);
        return "redirect:/users/list";
    }

    @GetMapping("/show_update_form/{id}")
    public ModelAndView showUpdateForm(@PathVariable("id") Long id) {
        ModelAndView mav = new ModelAndView("user/updateUser");
        Optional<User> user = userService.findById(id);
        mav.addObject("user", user.get());
        return mav;
    }

    @PostMapping("/updateUser")
    public String updateUser(@ModelAttribute("user") User user) {
        Optional<User> existingUser = userService.findByEmail(user.getEmail());

        if (existingUser.isPresent()) {
            User dbUser = existingUser.get();
            // Nếu mật khẩu không được nhập, giữ mật khẩu cũ
            if (user.getPasswordHash() == null || user.getPasswordHash().isEmpty()) {
                user.setPasswordHash(dbUser.getPasswordHash());
            }

            // Chỉ lưu nếu user có ID hợp lệ
            if (user.getId() != null ) {
                userService.save(user);
                return "redirect:/users/profile/" + user.getId();
            } else {
                return "redirect:/users?error=invalidUser";
            }
        } else {
            return "redirect:/users?error=userNotFound";
        }
    }


    ////////////////////////////////////////////////////////////////////
    //    SIGN UP

    @GetMapping("/show_signup_form")
    public ModelAndView signup() {
        ModelAndView mav = new ModelAndView();
        User user = new User();
        mav.addObject("user", user);
        mav.setViewName("user/signup");
        return mav;
    }

    @PostMapping("/signup")
    public String singup(@ModelAttribute("user") User user, HttpSession session) {
//        user.setRegisteredAt(Instant.now());
        user.setPasswordHash(userService.setPasswordHash(user.getPasswordHash()));
        userService.save(user);
        session.setAttribute("currentUser", user);
        return "redirect:/users/home";
    }


    //    SIGN IN
    @GetMapping("/show_signin_form")
    public ModelAndView signin() {
        ModelAndView mav = new ModelAndView();
        User user = new User();
        mav.addObject("user", user);
        mav.setViewName("user/signin");
        return mav;
    }


@PostMapping("/signin")
public String signin(@ModelAttribute("user") User user, Model model, HttpSession session) {
    Optional<User> existingUser = userService.findByEmail(user.getEmail());
    if (existingUser.isPresent()) {
        boolean isPasswordMatch = userService.validatePassword(user.getPasswordHash(), existingUser.get().getPasswordHash());
        if (isPasswordMatch) {
            session.setAttribute("currentUser", existingUser.get());
            return "redirect:/users/home";
        } else {
            model.addAttribute("error", "Invalid email or password");
            return "user/signin";
        }
    } else {
        model.addAttribute("error", "Invalid email or password");
        return "user/signin";
    }
}


    @GetMapping("/guest")
    public ModelAndView guest() {
        ModelAndView mav = new ModelAndView();
        User user = new User();
        mav.setViewName("guest");
        mav.addObject("user", user);
        return mav;
    }

    @GetMapping("/profile/{id}")
    public ModelAndView profile(@PathVariable("id") Long id) {
        ModelAndView mav = new ModelAndView();
        // Lay user hien tai dang dang nhap
        Optional<User> user = userService.findById(id);

        mav.addObject("user", user.get());
        mav.setViewName("user/profile");
        return mav;
    }

    @GetMapping("/signout")
    public String logout(HttpSession session) {
        return "redirect:/users/guest";
    }


}