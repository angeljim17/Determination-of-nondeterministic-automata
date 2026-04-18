defmodule AutomataBasico do

  def obtener_nfa do
    %{
      estados: [0,1,2,3],
      simbolos: [:a, :b],
      conexiones: %{
        {0, :a} => [0,1],
        {0, :b} => [0],
        {1, :b} => [2],
        {2, :b} => [3]
      },
      inicio: 0,
      aceptacion: [3]
    }
  end

  def determinizar(automata) do
    lista_estados = generar_estados(automata)
    mapa_transiciones = generar_transiciones(automata)
    estado_inicial = [automata.inicio]
    estados_finales = buscar_finales(automata)

    %{
      estados: lista_estados,
      simbolos: automata.simbolos,
      conexiones: mapa_transiciones,
      inicio: estado_inicial,
      aceptacion: estados_finales
    }
  end

  def generar_estados(automata) do
    recorrer([[automata.inicio]], [], automata)
  end

  defp recorrer([], visitados, _), do: visitados

  defp recorrer([actual | resto], visitados, automata) do
    siguientes =
      Enum.map(automata.simbolos, fn simb ->
        mover(actual, simb, automata)
      end)
      |> Enum.uniq()

    nuevos =
      Enum.filter(siguientes, fn elem ->
        elem != [] and elem != actual and
        not Enum.member?(visitados, elem) and
        not Enum.member?(resto, elem)
      end)

    recorrer(resto ++ nuevos, visitados ++ [actual], automata)
  end

  def generar_transiciones(automata) do
    generar_estados(automata)
    |> Enum.map(fn estado ->
      construir_transicion(estado, automata)
    end)
    |> Enum.reduce(%{}, fn mapa, acc -> Map.merge(acc, mapa) end)
  end

  def construir_transicion(estado, automata) do
    automata.simbolos
    |> Enum.map(fn simb ->
      {{estado, simb}, mover(estado, simb, automata)}
    end)
    |> Map.new()
  end

  def buscar_finales(automata) do
    generar_estados(automata)
    |> Enum.filter(fn conjunto ->
      Enum.any?(conjunto, fn e -> e in automata.aceptacion end)
    end)
  end

  def mover(estados, simbolo, automata) do
    estados
    |> Enum.map(fn e -> Map.get(automata.conexiones, {e, simbolo}, []) end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.sort()
  end

end
