# Determinización de autómatas no deterministas

Implementación en **Elixir** de algoritmos para trabajar con autómatas finitos no deterministas (AFND) y convertirlos a autómatas deterministas (AFD).

## Stack

- Elixir ~1.14
- Mix

## Problemas implementados

| Módulo | Descripción |
|--------|-------------|
| `AutomataBasico` | Determinización de un AFND básico |
| `Problema2` | Segundo ejercicio de transformación de autómatas |
| `Problema3` | Tercer ejercicio de transformación de autómatas |

## Cómo ejecutar

```bash
mix deps.get
mix test
```

## Estructura

```
lib/
├── problema1.ex    # AutomataBasico — determinización básica
├── problema2.ex
└── problema3.ex
test/
├── problema1_test.exs
├── problema2_test.exs
└── problema3_test.exs
```

## Contexto

Proyecto académico de teoría de la computación (ITESM).

## Autor

**Ángel Jiménez Morales** — [GitHub](https://github.com/angeljim17)
