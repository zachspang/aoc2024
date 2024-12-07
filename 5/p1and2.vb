Imports System

Module Program
    Dim rules As New List(Of String)
    Public Function PageComparer(x As Object, y As Object) As Integer
        If rules.Contains(x & "|" & y) Then
            Return -1
        End If
        Return 1
    End Function

    Sub Main(args As String())
        Dim filename As String = "C:\Users\spang\Desktop\Projects\aoc2024\5\input.txt"

        If System.IO.File.Exists(filename) Then
            Dim inputReader As New IO.StreamReader(filename)
            Dim line As String
            Dim part1Sum As Integer
            Dim part2Sum As Integer

            'Loop through rules
            While Not inputReader.EndOfStream
                line = inputReader.ReadLine
                If line = "" Then
                    Exit While
                End If

                rules.Add(line)
            End While

            Dim updateArr As List(Of String)
            Dim sortedUpdateArr As List(Of String)

            'Loop through updates
            While Not inputReader.EndOfStream
                line = inputReader.ReadLine
                updateArr = line.Split(",").ToList
                sortedUpdateArr = New List(Of String)(updateArr)
                sortedUpdateArr.Sort(AddressOf PageComparer)

                'For each update check if it is sorted
                If updateArr.SequenceEqual(sortedUpdateArr) Then
                    part1Sum += updateArr(updateArr.Count \ 2)
                Else
                    part2Sum += sortedUpdateArr(sortedUpdateArr.Count \ 2)
                End If
            End While

            Console.WriteLine(part1Sum)
            Console.WriteLine(part2Sum)
            inputReader.Close()
        End If

    End Sub

End Module
