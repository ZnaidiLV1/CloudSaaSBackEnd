package org.example.repository;

import org.example.entity.Tag;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface TagRepository extends JpaRepository<Tag, Long> {

    Optional<Tag> findByKeyAndValue(String key, String value);

    List<Tag> findByKey(String key);
}