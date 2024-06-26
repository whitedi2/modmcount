﻿
&НаКлиенте
Процедура СчетБУПриИзменении(Элемент)
	СчетБУПриИзмененииНаСервере(Запись.СчетБУ, Не Элемент = Неопределено);
КонецПроцедуры

&НаСервере
Процедура СчетБУПриИзмененииНаСервере(СчетСсылка, Изменять)

	МаксКоличествоСубконто = Метаданные.ПланыСчетов.Хозрасчетный.МаксКоличествоСубконто;
	СчетВидыСубконто = СчетСсылка.ВидыСубконто;
	
	Для Индекс = 1 По МаксКоличествоСубконто Цикл
		
		Если Индекс <= СчетВидыСубконто.Количество() Тогда
			
			Если Изменять Тогда
				Запись["СубконтоБУ" + Индекс] = СчетВидыСубконто[Индекс - 1].ВидСубконто;
			КонецЕсли;
			
			//Элементы["СубконтоБУ" + Индекс].ТолькоПросмотр = Ложь;
		Иначе
			
			Если Изменять Тогда
				Запись["СубконтоБУ" + Индекс] = Неопределено;
			КонецЕсли;  
			
			//Элементы["СубконтоБУ" + Индекс].ТолькоПросмотр = Истина;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры


&НаКлиенте
Процедура СчетУУПриИзменении(Элемент)
	СчетУУПриИзмененииНаСервере(Запись.СчетУУ,  Не Элемент = Неопределено);
КонецПроцедуры

&НаСервере
Процедура СчетУУПриИзмененииНаСервере(СчетСсылка, Изменять)

	МаксКоличествоСубконто = Метаданные.ПланыСчетов.Учетный.МаксКоличествоСубконто;
	СчетВидыСубконто = СчетСсылка.ВидыСубконто;
	Для Индекс = 1 По МаксКоличествоСубконто Цикл
		Если Индекс <= СчетВидыСубконто.Количество() Тогда
			Если Изменять Тогда
				Запись["СубконтоУУ" + Индекс] = СчетВидыСубконто[Индекс - 1].ВидСубконто;
			КонецЕсли;
			Элементы["СубконтоУУ" + Индекс].ТолькоПросмотр = Ложь;
			Элементы["ЗначениеСубконтоУУ" + Индекс].ТолькоПросмотр = Ложь;
		Иначе
			Если Изменять Тогда
				Запись["СубконтоУУ" + Индекс] = Неопределено;
				Запись["ЗначениеСубконтоУУ" + Индекс] = Неопределено;
			КонецЕсли;
			Элементы["СубконтоУУ" + Индекс].ТолькоПросмотр = Истина;
			Элементы["ЗначениеСубконтоУУ" + Индекс].ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СчетБУПриИзмененииНаСервере(Запись.СчетБУ, Ложь);
	СчетУУПриИзмененииНаСервере(Запись.СчетУУ, Ложь);
КонецПроцедуры
