package com.masr.simplelibrary.controller;

import com.masr.simplelibrary.dtos.BookRequestDto;
import com.masr.simplelibrary.models.Book;
import com.masr.simplelibrary.services.BookService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class BookController {

    private BookService bookService;

    public BookController(BookService bookService) {
        this.bookService = bookService;
    }


    @GetMapping("/getAllBooks")
    public ResponseEntity<List<Book>> getAllBooks() {
        return ResponseEntity.ok(bookService.getAllBooks());
    }


    @PostMapping(consumes = "multipart/form-data", path = "/createBook")
    public ResponseEntity<Book> createBook(@ModelAttribute BookRequestDto bookRequest) {
        try {
            Book savedBook = bookService.saveBook(bookRequest);
            return ResponseEntity.ok(savedBook);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().build();
        }
    }

}

