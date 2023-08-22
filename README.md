# Using Bloom Filters for Spell Checkers

An "infrastructure" that allows users to create and experiment with different spell checkers that are based on hash functions.

This project consists of three parts:
- The key function "key" which takes a word as input and maps it to its key using the provided cvt character to value mapping.
- A function that generates hash functions based on the division method gen-hash-division-method, and a function that generates hash functions based on the multiplication method gen-hash-multiplication-method.
- A function gen-checker that takes as input a list of hash functions and a dictionary of words, and returns a spell checker. A spell checker is a function that takes a word as input and returns either #t or #f, indicating a correctly or incorrectly spelled word, respectively
