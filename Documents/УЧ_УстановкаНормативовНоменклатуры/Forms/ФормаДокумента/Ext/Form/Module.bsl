﻿
&НаКлиенте
Процедура НормативыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Элемент.ТекущиеДанные.Норматив = ПредопределенноеЗначение("Справочник.НормативыНоменклатуры.ИндивидуальноеХранение") Тогда
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("Булево"));
		Элементы.НормативыЗначение.ОграничениеТипа = Новый ОписаниеТипов(МассивТипов);
	Иначе
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("Число"));
		Элементы.НормативыЗначение.ОграничениеТипа = Новый ОписаниеТипов(МассивТипов,,,Новый КвалификаторыЧисла(16, 2));
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	сабОбщегоНазначенияБУХ.ФормаДокументаУУОбработкаБУПередЗаписью(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры
