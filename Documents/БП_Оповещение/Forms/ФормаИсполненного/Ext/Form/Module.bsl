﻿&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СтруктураПоиска = Новый Структура("Исполнитель", БюджетныйНаСервере.ПолучитьПользователя());
	ОтобраннаяСтрока = Объект.СписокИсполнителей.НайтиСтроки(СтруктураПоиска);
	Для каждого ТекСтрока Из ОтобраннаяСтрока Цикл
		Если ТекСтрока.ДатаВыполнения = '000101010000' Тогда
			ТекДата = "в процессе ознакомления."
		Иначе
			ТекДата = Строка(ТекСтрока.ДатаВыполнения);
		КонецЕсли;
		Комментарий = ТекСтрока.Комментарии + "
		|(Дата ознакомления: " + ТекДата + ")";	
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	//ПоказатьЗначение(Неопределено, Объект.Гиперссылка);
	
	БюджетныйНаКлиенте.УниверсальнаяПечать(Объект.Гиперссылка, Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция Печать(ТабДок, ПараметрКоманды)
	ИмяДока = ПараметрКоманды[0].ПолучитьОбъект().Метаданные().Имя;
	Документы[ИмяДока].Печать(ТабДок, ПараметрКоманды);
	//Документы.Д_ЗаявкаНаОтгрузку.Печать(ТабДок, ПараметрКоманды);		
	Возврат  ИмяДока;
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПрикрепленныеФайлы" Тогда	
		сабОбщегоНазначенияКлиент.ОбновитьКоличествоПрикрепленныхФайлов(ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	сабОбщегоНазначения.ОбновитьКоличествоПрикрепленныхФайловСервер(ЭтаФорма);
КонецПроцедуры





















