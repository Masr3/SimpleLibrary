package com.masr.simplelibrary.repositories;

import com.masr.simplelibrary.models.Book;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BookRepository extends JpaRepository<Book, Long> {
}
