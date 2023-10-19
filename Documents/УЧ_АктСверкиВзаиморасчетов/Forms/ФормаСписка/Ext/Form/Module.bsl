﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Список.Параметры.УстановитьЗначениеПараметра("ДоступныеПредприятия", БюджетныйНаСервере.ПолучитьПредприятия());
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" Тогда
		Если Параметр.Свойство("ФормаВладелецУИД") И Параметр.ФормаВладелецУИД = ЭтаФорма.УникальныйИдентификатор Тогда
			сабОбщегоНазначения.ПрикрепитьФайлКДокументу(Параметр); 
		КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
КонецПроцедуры
