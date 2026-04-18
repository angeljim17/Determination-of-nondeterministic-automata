defmodule PruebaCasoGrande do
  use ExUnit.Case

  test "cierre epsilon y determinización caso grande" do
    nfa = AutomataCasoGrande.obtener_ejemplo()
    dfa = AutomataCasoGrande.resolver_afnd_epsilon(nfa)

    assert AutomataCasoGrande.calcular_cierre(nfa, [0]) == [0,1,2,3,7]
    assert AutomataCasoGrande.calcular_cierre(nfa, [1]) == [1,2,3]
    assert AutomataCasoGrande.calcular_cierre(nfa, [6]) == [1,2,3,6,7]

    assert dfa.inicio == [0,1,2,3,7]
  end
end
