defmodule AutomataCasoGrande do


  def obtener_ejemplo do
    %{
      estados: [0,1,2,3,4,5,6,7,8,9,10],
      simbolos: [:a, :b],
      conexiones: %{
        {0, :epsilon} => [1,7],
        {1, :epsilon} => [2,3],
        {2, :a} => [4],
        {3, :b} => [5],
        {4, :epsilon} => [6],
        {5, :epsilon} => [6],
        {6, :epsilon} => [1,7],
        {7, :a} => [8],
        {8, :b} => [9],
        {9, :b} => [10]
      },
      inicio: 0,
      aceptacion: [10]
    }
  end


  def calcular_cierre(automata, lista) do
    expandir(lista, lista, automata)
  end

  defp expandir([], visitados, _), do: Enum.sort(visitados)

  defp expandir([actual | resto], visitados, automata) do
    siguientes = Map.get(automata.conexiones, {actual, :epsilon}, [])

    nuevos =
      Enum.filter(siguientes, fn x ->
        not Enum.member?(visitados, x)
      end)

    expandir(resto ++ nuevos, visitados ++ nuevos, automata)
  end


  def mover(estados, simbolo, automata) do
    estados
    |> Enum.map(fn e -> Map.get(automata.conexiones, {e, simbolo}, []) end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.sort()
  end


  def construir_estados(automata) do
    inicial = calcular_cierre(automata, [automata.inicio])
    explorar([inicial], [], automata)
  end

  defp explorar([], visitados, _), do: Enum.sort(visitados)

  defp explorar([actual | cola], visitados, automata) do
    siguientes =
      Enum.map(automata.simbolos, fn s ->
        calcular_cierre(automata, mover(actual, s, automata))
        |> Enum.sort()
      end)
      |> Enum.uniq()

    nuevos =
      Enum.filter(siguientes, fn x ->
        x != [] and x != actual and
        not Enum.member?(visitados, x) and
        not Enum.member?(cola, x)
      end)

    explorar(cola ++ nuevos, visitados ++ [actual], automata)
  end


  def construir_transiciones(automata) do
    construir_estados(automata)
    |> Enum.map(fn estado ->
      transicion(estado, automata)
    end)
    |> Enum.reduce(%{}, fn m, acc -> Map.merge(acc, m) end)
  end

  def transicion(estado, automata) do
    automata.simbolos
    |> Enum.map(fn s ->
      {{estado, s},
       calcular_cierre(automata, mover(estado, s, automata)) |> Enum.sort()}
    end)
    |> Map.new()
  end


  def obtener_inicial(automata) do
    calcular_cierre(automata, [automata.inicio])
  end


  def obtener_finales(automata) do
    construir_estados(automata)
    |> Enum.filter(fn grupo ->
      Enum.any?(grupo, fn x -> x in automata.aceptacion end)
    end)
  end


  def resolver_afnd_epsilon(automata) do
    %{
      estados: construir_estados(automata),
      simbolos: automata.simbolos,
      conexiones: construir_transiciones(automata),
      inicio: obtener_inicial(automata),
      aceptacion: obtener_finales(automata)
    }
  end

end
