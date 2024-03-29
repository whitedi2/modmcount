﻿////////////////////////////////////////////////////////////////////////////////
// Функции и процедуры обеспечения формирования бухгалтерских отчетов.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура заполняет список значений с ключами отчетов, которые поддерживаются подсистемой
//
Процедура СписокОтчетовПоддерживаемыхПодсистемой(СписокОтчетов) Экспорт
	
	СписокОтчетов.Добавить("Отчет." + Метаданные.Отчеты.Продажи.Имя);
	СписокОтчетов.Добавить("Отчет." + Метаданные.Отчеты.ПродажиПоМесяцам.Имя);
	СписокОтчетов.Добавить("Отчет." + Метаданные.Отчеты.ЗадолженностьПокупателей.Имя);
	СписокОтчетов.Добавить("Отчет." + Метаданные.Отчеты.ЗадолженностьПоставщикам.Имя);
	СписокОтчетов.Добавить("Отчет." + Метаданные.Отчеты.ЗадолженностьПокупателейПоСрокамДолга.Имя);
	СписокОтчетов.Добавить("Отчет." + Метаданные.Отчеты.ЗадолженностьПоставщикамПоСрокамДолга.Имя);
	
	СписокОтчетов.Добавить("Отчет." + Метаданные.Отчеты.ОборотныеСредства.Имя);
	СписокОтчетов.Добавить("Отчет." + Метаданные.Отчеты.ДинамикаЗадолженностиПокупателей.Имя);
	СписокОтчетов.Добавить("Отчет." + Метаданные.Отчеты.ДинамикаЗадолженностиПоставщикам.Имя);
	СписокОтчетов.Добавить("Отчет." + Метаданные.Отчеты.ОстаткиДенежныхСредств.Имя);
	СписокОтчетов.Добавить("Отчет." + Метаданные.Отчеты.ПоступленияДенежныхСредств.Имя);
	СписокОтчетов.Добавить("Отчет." + Метаданные.Отчеты.РасходыДенежныхСредств.Имя);
	СписокОтчетов.Добавить("Отчет." + Метаданные.Отчеты.АнализДвиженийДенежныхСредств.Имя);	
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


