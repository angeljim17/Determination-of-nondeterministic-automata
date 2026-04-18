defmodule PruebaBasica do
  use ExUnit.Case

  test "transformacion NFA a DFA" do
    nfa = AutomataBasico.obtener_nfa()
    dfa = AutomataBasico.determinizar(nfa)

    assert dfa.inicio == [0]
    assert dfa.aceptacion == [[0,3]]

    assert dfa.conexiones[{[0], :a}] == [0,1]
    assert dfa.conexiones[{[0,1], :b}] == [0,2]
    assert dfa.conexiones[{[0,2], :b}] == [0,3]
    assert dfa.conexiones[{[0,3], :b}] == [0]

    estados_esperados = [[0], [0,1], [0,2], [0,3]]
    assert Enum.sort(dfa.estados) == Enum.sort(estados_esperados)
  end
end
