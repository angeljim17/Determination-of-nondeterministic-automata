defmodule AutomataConEpsilon do


  def resolver_afnd_epsilon(datos) do
    %{
      estados: generar_conjuntos(datos),
      simbolos: datos.simbolos,
      conexiones: construir_transiciones(datos),
      inicio: obtener_inicio(datos),
      aceptacion: obtener_finales(datos)
    }
  end

  def obtener_ejemplo do
    %{
      estados: [0,1,2,3],
      simbolos: [:a, :b],
      conexiones: %{
        {0, :epsilon} => [2],
        {1, :epsilon} => [3],
        {0, :a} => [0,1],
        {0, :b} => [0],
        {1, :b} => [2],
        {2, :b} => [3]
      },
      inicio: 0,
      aceptacion: [3]
    }
  end

  def calcular_cierre(datos, lista_inicial) do
    expandir(lista_inicial, lista_inicial, datos)
  end

  defp expandir([], visitados, _), do: Enum.sort(visitados)

  defp expandir([actual | resto], visitados, datos) do
    siguientes = Map.get(datos.conexiones, {actual, :epsilon}, [])

    nuevos =
      Enum.filter(siguientes, fn x ->
        not Enum.member?(visitados, x)
      end)

    expandir(resto ++ nuevos, visitados ++ nuevos, datos)
  end


  def mover(estados, simbolo, datos) do
    estados
    |> Enum.map(fn e -> Map.get(datos.conexiones, {e, simbolo}, []) end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.sort()
  end


  def generar_conjuntos(datos) do
    inicio = calcular_cierre(datos, [datos.inicio])
    recorrer([inicio], [], datos)
  end

  defp recorrer([], visitados, _), do: Enum.sort(visitados)

  defp recorrer([actual | cola], visitados, datos) do
    siguientes =
      Enum.map(datos.simbolos, fn simb ->
        calcular_cierre(datos, mover(actual, simb, datos))
        |> Enum.sort()
      end)
      |> Enum.uniq()

    nuevos =
      Enum.filter(siguientes, fn elem ->
        elem != [] and elem != actual and
        not Enum.member?(visitados, elem) and
        not Enum.member?(cola, elem)
      end)

    recorrer(cola ++ nuevos, visitados ++ [actual], datos)
  end



  def construir_transiciones(datos) do
    generar_conjuntos(datos)
    |> Enum.map(fn estado ->
      construir_transicion(estado, datos)
    end)
    |> Enum.reduce(%{}, fn mapa, acc -> Map.merge(acc, mapa) end)
  end

  def construir_transicion(estado, datos) do
    datos.simbolos
    |> Enum.map(fn simb ->
      {{estado, simb},
       calcular_cierre(datos, mover(estado, simb, datos)) |> Enum.sort()}
    end)
    |> Map.new()
  end


  def obtener_inicio(datos) do
    calcular_cierre(datos, [datos.inicio])
  end

  def obtener_finales(datos) do
    generar_conjuntos(datos)
    |> Enum.filter(fn conjunto ->
      Enum.any?(conjunto, fn e -> e in datos.aceptacion end)
    end)
  end

end
