
/// Represents a function that accepts two arguments and produces a result.
typedef BiFunction<T,U,R> = R Function(T first, U second);

/// Represents an operation that accepts two input arguments and returns no
/// result
typedef BiConsumer<T,U> = BiFunction<T, U, void>;

/// Represents an operation upon two operands of the same type, producing a
/// result of the same type as the operands.
typedef BinaryOperator<T> = BiFunction<T, T, T>;

/// Represents a predicate (boolean-valued function) of two arguments.
typedef BiPredicate<T,U> = BiFunction<T, U, bool>;

/// Represents a supplier of results.
typedef Supplier<T> = T Function();

/// Represents a supplier of boolean-valued results.
typedef BooleanSupplier = Supplier<bool>;

/// Represents a function that accepts one argument and produces a result.
typedef SingleFunction<T,R> = R Function(T arg);

/// Represents an operation that accepts a single input argument and returns no
/// result.
typedef Consumer<T> = SingleFunction<T, void>;

/// Represents a predicate (boolean-valued function) of one argument.
typedef Predicate<T> = SingleFunction<T, bool>;

/// Represents an operation on a single operand that produces a result of the
/// same type as its operand.
typedef UnaryOperator<T> = SingleFunction<T, T>;
