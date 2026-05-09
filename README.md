# Catspeak++
A monthly extension of Catspeak v3 by @katsaii, with support for constant aware arguments & compile-time function calls. As well as some minor optimations made in place, and exposure of `params` and `params_count`.

## What does constant aware arguments mean?

In Catspeak, a function may be called like `power(num, 2)`, and Catspeak will evaluate & call each value whenever the program is ran. While fine for smaller arguments, this is a minor performance overhead that is not needed.<br>
Catspeak++ handles this by evaluating constants during compile-time, and will store the value as-is, while keeping everything else the same.
This allows Catspeak to instead only update values that are not constant (such as `num`) at runtime. This also means `power(2, 2)` will be aware that both are constants, and will call `power` directly with the arguments as-is.

## What does compile-time function calls mean?
Going back to our `power(2, 2)` example, it does seem a lil bit silly for a function that returns a value that doesn't modify the global state (doesn't affect future calls), shouldn't need to be called with the arguments at runtime.
Catspeak++ introduces compile-time function calls. Which can be accessed by `environment.interface.exposeCompileTimeFunction(name, func, ...)`

In the above case, if `power` is exposed as a compile-time function `Catspeak.interface.exposeCompileTimeFunction("power", power)`, and all of the arguments are constants (`power(2, 2)`), Catspeak will instead call & store the resulting value as<br>
as is at compile time. If a singular non-value (number or string) is introduced within the argument calls, it will fallback to just being a runtime call.

## What other optimisations have been made?
- dot access & struct keys that are constant, are replaced by a hash lookup. (index only as of writing)
- Some bypasses to `script_get_index` on the current runtime, as there is a speed penalty in regards to calling `script_get_index` in the worse of cases. (Applies to exposed functions/methods only)
- `method_call` replacing `script_execute_ext` in some places. (Mainly the constant aware variety calls)

## params & params_count?
Like in GML, you are able to access arguments of a function via `argument[index]` and `argument_count`. Catspeak has its own, but this wasn't previously exposed as this was experimental and introduced in a PR for GMLspeak (another work of mine).<br>
I have exposed this from Catspeak++ directly, so now anyone can use `params` and `params_count` within Catspeak!

## Will more features and optimisations come?
Optimisations? Maybe. It really depends on whether it is worth my time or not. But in truth, I mainly intend on keeping compatibility with Catspeak v3. Outside of `exposeCompileTimeFunction` and exposure of `params`/`params_count`, no other feature<br>
will be coming to Catspeak++ at this time.
