﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТочкиОплаты = Новый Массив;
	ТочкиОплаты.Добавить(Перечисления.Согласование1ТочкиМаршрута.Действие5);
	ТочкиОплаты.Добавить(Перечисления.Согласование1ТочкиМаршрута.Завершение);
	ТочкиОплаты.Добавить(Перечисления.Согласование1ТочкиМаршрута.Действие1);
	
	ТипыДокументов = Новый Массив;
	ТипыДокументов.Добавить(Тип("ДокументСсылка.Д_ЗаявкаНаОплату"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.Д_ЗаявкаНаФинансирование"));
	
	Если ТипЗнч(Параметры.Отбор) = Тип("Структура") И Параметры.Отбор.Свойство("Документ") Тогда
		Если ТипЗнч(Параметры.Отбор.Документ) = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
			ТипыДокументов.Добавить(Тип("ДокументСсылка.СчетНаОплатуПокупателю"));
		КонецЕсли;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", НачалоДня(ТекущаяДата()));
	Список.Параметры.УстановитьЗначениеПараметра("ДоступныеПредприятия", ПараметрыСеанса.ДоступныеПредприятия);
	Список.Параметры.УстановитьЗначениеПараметра("ТочкиОплаты", ТочкиОплаты);
	Список.Параметры.УстановитьЗначениеПараметра("ТипыДокументов", ТипыДокументов);
	
	Если Параметры.Отбор.Количество() И НЕ Элементы.Найти("СоздатьРеестрОплатОбщий") = Неопределено Тогда
		Элементы.СоздатьРеестрОплатОбщий.Видимость = Ложь;	
	КонецЕсли;
	
	ИспользоватьКлючиАналитикиБюджета = Справочники.сабМониторВнедрения.ПолучитьЗначениеНастройки("ИспользоватьКлючиАналитикиБюджета");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	//СтандартнаяОбработка = Ложь;
	ТекДанные = Элементы.Список.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекДанные.Документ) Тогда
		
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(,ТекДанные.Документ);
	Иначе
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("РегистрСведений.сабГрафикПлатежей.Форма.ФормаЗаписиПростая", Новый Структура("Ключ", Элементы.РасшифровкаГрафика.ТекущаяСтрока)); 
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРеестрОплатОбщий(Команда)
	ОткрытьФорму("Документ.Д_ЗаявкаНаОплату.ФормаОбъекта", Новый Структура("Основание", Новый Структура("ДатаГрафика, ВидОплаты, РежимРаботы", ТекущаяДата(), Неопределено, "График")));
КонецПроцедуры

&НаКлиенте
Процедура ГрафикРазбить(Команда)
	ТекДанные = Элементы.Список.ТекущаяСтрока;
	Если НЕ ТекДанные = Неопределено Тогда
		ТекФорма = ПолучитьФорму("Обработка.сабПлатежныйКалендарь.Форма.ФормаРазбивкиПлатежа");
		ТекФорма.ИмяФормыВладельца = ЭтаФорма.ИмяФормы;
		ТекФорма.Дата = Элементы.Список.ТекущиеДанные.ДатаПлатежа;
		
		Если ТекФорма.Дата <= НачалоДня(ТекущаяДата()) Тогда
			ТекФорма.Дата = ТекущаяДата() + 24*60*60;
		КонецЕсли;
		
		ТекФорма.СуммаПлатежа = Элементы.Список.ТекущиеДанные.Сумма;
		ТекФорма.Открыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ГрафикСобратьПлатеж(Команда)
	ТекДанныеГрафика = Элементы.Список.ТекущаяСтрока;
	Если НЕ ТекДанныеГрафика = Неопределено Тогда
		ТекФорма = ПолучитьФорму("Обработка.сабПлатежныйКалендарь.Форма");
		МассивДат = Новый Массив;
		ТекФорма.СобратьПлатежНаСервере(ТекДанныеГрафика, МассивДат);
		Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "сабРазбитьПлатеж" И Параметр.ИмяФормыВладельца = ЭтаФорма.ИмяФормы Тогда
		//ПеренестиЗаявкуНаКлиенте(Параметр.Дата, Параметр.Сумма);
		ТекФорма = ПолучитьФорму("Обработка.сабПлатежныйКалендарь.Форма");
		ТекФорма.ПеренестиЗаписьНаСервере(Элементы.Список.ТекущаяСтрока, Параметр.Дата, Параметр.Сумма, Элементы.Список.ТекущиеДанные.Источник);
		Элементы.Список.Обновить();	
	КонецЕсли;
	Если ИмяСобытия = "сабОбноватьПлатежныйКалендарь" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("ОбновитьСписок", 60);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок() Экспорт
	Элементы.Список.Обновить();
КонецПроцедуры
