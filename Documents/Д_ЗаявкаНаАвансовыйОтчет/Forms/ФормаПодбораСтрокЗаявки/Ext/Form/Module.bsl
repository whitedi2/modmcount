﻿
&НаКлиенте
Процедура Выбрать(Команда)
	МассивУИДов = Новый Массив;
	ОтобранныеСтроки = СтрокиЗаявкиНаОплату.НайтиСтроки(Новый Структура("Выбран", Истина));
	Для каждого ТекСтрока Из ОтобранныеСтроки Цикл
		МассивУИДов.Добавить(Новый Структура("ДокОснование, УИДСтрокиДокОснования",ТекСтрока.Ссылка, ТекСтрока.УИДСтроки));
	КонецЦикла; 
	Оповестить("ВыбраныСтрокиЗаявки", МассивУИДов);
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры.Заявка) = Тип("Массив") Тогда
		МассивЗаявок = Параметры.Заявка;
	ИначеЕсли ТипЗнч(Параметры.Заявка) = Тип("СписокЗначений") Тогда
		МассивЗаявок = Параметры.Заявка.ВыгрузитьЗначения();
	Иначе
		МассивЗаявок = новый Массив;
		МассивЗаявок.Добавить(Параметры.Заявка);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Д_ЗаявкаНаОплатуЗаявкаБезнал.НомерСтроки,
	|	Д_ЗаявкаНаОплатуЗаявкаБезнал.СтатьяДДС,
	|	Д_ЗаявкаНаОплатуЗаявкаБезнал.СуммаДДС,
	|	Д_ЗаявкаНаОплатуЗаявкаБезнал.Контрагент,
	|	Д_ЗаявкаНаОплатуЗаявкаБезнал.НазначениеПлатежа,
	|	Д_ЗаявкаНаОплатуЗаявкаБезнал.ЦФО,
	|	Д_ЗаявкаНаОплатуЗаявкаБезнал.Источник,
	|	Д_ЗаявкаНаОплатуЗаявкаБезнал.Подразделение,
	|	Д_ЗаявкаНаОплатуЗаявкаБезнал.УИДСтроки,
	|	Д_ЗаявкаНаОплатуЗаявкаБезнал.ВыдачаВПодОтчет,
	|	Д_ЗаявкаНаОплатуЗаявкаБезнал.Ссылка
	|ИЗ
	|	Документ.Д_ЗаявкаНаОплату.ЗаявкаБезнал КАК Д_ЗаявкаНаОплатуЗаявкаБезнал
	|ГДЕ
	|	Д_ЗаявкаНаОплатуЗаявкаБезнал.Ссылка В (&Ссылка)";
	
	Запрос.УстановитьПараметр("Ссылка", МассивЗаявок);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = СтрокиЗаявкиНаОплату.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		Если НЕ Параметры.УИДЫ.Найти(Выборка.УИДСтроки) = Неопределено Тогда
			НоваяСтрока.Выбран = Истина;	
		КонецЕсли;
		
		Если НЕ СписокЗаявок.НайтиСтроки(Новый Структура("ДокОснование", Выборка.Ссылка)).Количество() Тогда
			НоваяСтрока = СписокЗаявок.Добавить();
			НоваяСтрока.ДокОснование = Выборка.Ссылка;	
		КонецЕсли;
		
	КонецЦикла;
	
	ЗаполнитьКоличествоСтрок();
	
	Если МассивЗаявок.Количество() < 2 Тогда
		Элементы.СписокЗаявок.Видимость = Ложь;
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКоличествоСтрок()
	Для каждого ТекСтрока Из СписокЗаявок Цикл
		ОтобранныеСтроки = СтрокиЗаявкиНаОплату.НайтиСтроки(Новый Структура("Ссылка, Выбран", ТекСтрока.ДокОснование, Истина));
		ТекСтрока.КоличествоСтрок = ОтобранныеСтроки.Количество();
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура СтрокиЗаявкиНаОплатуВыбранПриИзменении(Элемент)
	ЗаполнитьКоличествоСтрок();
КонецПроцедуры

&НаКлиенте
Процедура СписокЗаявокПриАктивизацииСтроки(Элемент)
	ТекДанные = Элементы.СписокЗаявок.ТекущиеДанные;
	Если Не ТекДанные = Неопределено Тогда
		Элементы.СтрокиЗаявкиНаОплату.ОтборСтрок = Новый ФиксированнаяСтруктура(Новый Структура("Ссылка", ТекДанные.ДокОснование));
	Иначе
		Элементы.СтрокиЗаявкиНаОплату.ОтборСтрок = Неопределено;	
	КонецЕсли;
КонецПроцедуры


