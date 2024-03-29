﻿
Процедура ОбработкаПроведения(Отказ, Режим)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтруктураПредприятия.Ссылка КАК Подразделение
	|ИЗ
	|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|ГДЕ
	|	СтруктураПредприятия.Ссылка В ИЕРАРХИИ(&Подразделения)
	|
	|СГРУППИРОВАТЬ ПО
	|	СтруктураПредприятия.Ссылка";
	Запрос.УстановитьПараметр("Подразделения", Подразделения.Выгрузить().ВыгрузитьКолонку("Подразделение"));
	ВыборкаПоПодразделениям = Запрос.Выполнить().Выбрать();
	
	Движения.МаркетинговыеМероприятия.Записывать = Истина;
	Пока ВыборкаПоПодразделениям.Следующий() Цикл
		Для Каждого ТекСтрокаТовары Из Товары Цикл
			Движение = Движения.МаркетинговыеМероприятия.Добавить();
			Движение.ДатаЗаказовНач = ДатаЗаказовНач;
			Движение.ДатаЗаказовКон = ДатаЗаказовКон;
			Движение.ДатаРеализацииНач = ДатаРеализацииНач;
			Движение.ДатаРеализацииКон = ДатаРеализацииКон;
			Движение.ДатаПоставокНач = ДатаПоставокНач;
			Движение.ДатаПоставокКон = ДатаПоставокКон;
			Движение.Предприятие = Предприятие;
			Движение.Подразделение = ВыборкаПоПодразделениям.Подразделение;
			Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
			Движение.ВидМероприятия = ВидМероприятия;
			Движение.ЦенаПоступления = ТекСтрокаТовары.ЦенаПоступления;
			Движение.ЦенаРеализации = ТекСтрокаТовары.ЦенаРеализации;
			Движение.ДатаДокумента = Дата;
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	//из подписки на событие
	БюджетныйНаСервере.ДокументыПередЗаписьюПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	БюджетныйНаСервере.ПриУстановкеНовогоНомераПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
КонецПроцедуры
