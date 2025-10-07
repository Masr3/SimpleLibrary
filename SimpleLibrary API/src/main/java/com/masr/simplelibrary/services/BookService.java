package com.masr.simplelibrary.services;

import com.masr.simplelibrary.dtos.BookRequestDto;
import com.masr.simplelibrary.models.Book;
import com.masr.simplelibrary.repositories.BookRepository;
import com.squareup.okhttp.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@Service
public class BookService {

    private final BookRepository bookRepository;
    private final OkHttpClient client = new OkHttpClient();

    @Value("${supabase.url}")
    private String SUPABASE_URL;

    @Value("${supabase.api.key}")
    private String SUPABASE_API_KEY;

    public BookService(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    public List<Book> getAllBooks() {
        return bookRepository.findAll();
    }

    public Book getBookById(Long id) {
        return bookRepository.findById(id).orElseThrow();
    }


    public Book saveBook(BookRequestDto dto) throws IOException {
        Book book = new Book();
        book.setName(dto.getName());
        book.setAuthor(dto.getAuthor());

        if (dto.getCover() != null) {
            String coverUrl = uploadFileToSupabase(dto.getCover(), "covers/" + dto.getCover().getOriginalFilename());
            book.setCoverUrl(coverUrl);
        }

        if (dto.getPdf() != null) {
            String pdfUrl = uploadFileToSupabase(dto.getPdf(), "pdfs/" + dto.getPdf().getOriginalFilename());
            book.setPdfUrl(pdfUrl);
        }

        return bookRepository.save(book);
    }

    private String uploadFileToSupabase(MultipartFile file, String path) throws IOException {
        String fileUrl = SUPABASE_URL + "/storage/v1/object/media/" + path;

        RequestBody requestBody = RequestBody.create(
                MediaType.parse("application/octet-stream"),
                file.getBytes()
        );

        Request request = new Request.Builder()
                .url(fileUrl)
                .put(requestBody)
                .addHeader("Authorization", "Bearer " + SUPABASE_API_KEY)
                .build();

        Response response = null;
        try {
            response = client.newCall(request).execute();
            if (!response.isSuccessful()) {
                throw new IOException("Error uploading file: " + response);
            }
        } finally {
            if (response != null && response.body() != null) {
                response.body().close();
            }
        }

        return fileUrl;
    }
}