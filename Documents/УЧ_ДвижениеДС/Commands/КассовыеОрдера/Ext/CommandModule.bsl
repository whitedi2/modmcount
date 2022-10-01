﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	ПараметрыФормы = Новый Структура("", );
	ТекФорма = ПолучитьФорму("Документ.УЧ_ДвижениеДС.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, "КассовыеОрдера", ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
	НовыйОтбор = ТекФорма.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВидОперации");
	НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	НовыйОтбор.ПравоеЗначение = ПредопределенноеЗначение("Перечисление.ВидыОперацийДвиженияДС.КассовыйОрдер");
	
	ТекФорма.ВидОперацийДвиженияДС = НовыйОтбор.ПравоеЗначение;
	
	ТекФорма.Заголовок = "Кассовые ордера";
	
	Если НЕ ТекФорма.Элементы.Найти("ФормаСоздать") = Неопределено Тогда
		ТекФорма.Элементы.ФормаСоздать.Видимость = Ложь;
	КонецЕсли;
	Если НЕ ТекФорма.Элементы.Найти("ФормаГруппа2") = Неопределено Тогда
		ТекФорма.Элементы.ФормаГруппа2.Видимость = Истина;
	КонецЕсли;
	
	//Если НЕ ТекФорма.Элементы.Найти("ВидОперации") = Неопределено Тогда
	//	ТекФорма.Элементы.ВидОперации.Видимость = Ложь
	//КонецЕсли;
	
	ТекФорма.Открыть();
КонецПроцедуры
