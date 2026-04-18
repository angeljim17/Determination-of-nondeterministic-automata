defmodule PruebaEpsilon do
  use ExUnit.Case

  test "cierre epsilon" do
    nfa = AutomataConEpsilon.obtener_ejemplo()

    assert Enum.sort(AutomataConEpsilon.calcular_cierre(nfa, [0])) == [0,2]
    assert Enum.sort(AutomataConEpsilon.calcular_cierre(nfa, [1])) == [1,3]
    assert Enum.sort(AutomataConEpsilon.calcular_cierre(nfa, [2])) == [2]
    assert Enum.sort(AutomataConEpsilon.calcular_cierre(nfa, [3])) == [3]
  end
end
