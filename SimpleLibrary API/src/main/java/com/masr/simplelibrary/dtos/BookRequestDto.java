package com.masr.simplelibrary.dtos;

import lombok.Value;
import org.springframework.web.multipart.MultipartFile;

import java.io.Serializable;

/**
 * DTO for {@link com.masr.simplelibrary.models.Book}
 */

public class BookRequestDto  {


    private MultipartFile pdf;
    private MultipartFile cover;
    private String name;
    private String author;

    public MultipartFile getPdf() {
        return pdf;
    }

    public void setPdf(MultipartFile pdf) {
        this.pdf = pdf;
    }

    public MultipartFile getCover() {
        return cover;
    }

    public void setCover(MultipartFile cover) {
        this.cover = cover;
    }



    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }
}