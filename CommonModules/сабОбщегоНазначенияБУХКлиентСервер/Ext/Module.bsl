﻿// Рассчитывает сумму в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа
//
Процедура РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти, ЗначениеПустогоКоличества = 0) Экспорт

	СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Цена * ?(СтрокаТабличнойЧасти.Количество = 0, ЗначениеПустогоКоличества, СтрокаТабличнойЧасти.Количество);

КонецПроцедуры

// Рассчитывает сумму в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа
//
Процедура РассчитатьСуммуВРозницеТабЧасти(СтрокаТабличнойЧасти, ЗначениеПустогоКоличества = 0) Экспорт

	СтрокаТабличнойЧасти.СуммаВРознице = СтрокаТабличнойЧасти.ЦенаВРознице * ?(СтрокаТабличнойЧасти.Количество = 0, ЗначениеПустогоКоличества, СтрокаТабличнойЧасти.Количество);

КонецПроцедуры

// Расчет, исходя из постоянной суммы
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа.
//
Процедура РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, СуммаВключаетНДС = Ложь, ПрименяютсяСтавки4и2 = Ложь) Экспорт

	Если ТипЗнч(СтрокаТабличнойЧасти)=Тип("Структура") Тогда
		Если СтрокаТабличнойЧасти.Свойство("Сумма") И СтрокаТабличнойЧасти.Свойство("СтавкаНДС") Тогда
			СтрокаТабличнойЧасти.СуммаНДС = РассчитатьСуммуНДС(
												СтрокаТабличнойЧасти.Сумма,
												СуммаВключаетНДС,
												БюджетныйНаСервере.ВернутьРеквизит(СтрокаТабличнойЧасти.СтавкаНДС, "Ставка"));
		КонецЕсли;
	Иначе // Строка табличной части
		Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтавкаНДС) Тогда
			СтрокаТабличнойЧасти.СуммаНДС = РассчитатьСуммуНДС(
												СтрокаТабличнойЧасти.Сумма,
												СуммаВключаетНДС,
												БюджетныйНаСервере.ВернутьРеквизит(СтрокаТабличнойЧасти.СтавкаНДС, "Ставка"));
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Процедура выполняет стандартные действия по расчету плановой суммы
// в строке табличной части документа.
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа,
//
Процедура ПересчитатьПлановуюСумму(СтрокаТабличнойЧасти, ЗначениеПустогоКоличества = 0) Экспорт

	СтрокаТабличнойЧасти.СуммаПлановая = 
		?(СтрокаТабличнойЧасти.Количество = 0, ЗначениеПустогоКоличества, СтрокаТабличнойЧасти.Количество)
		* СтрокаТабличнойЧасти.ПлановаяСтоимость;

КонецПроцедуры

Процедура ПриИзмененииКоличествоЦена(Форма, ИмяТаблицы, ЗначениеПустогоКоличества = 0, ПрименяютсяСтавки4и2 = Ложь,ПересчитыватьСумму = Истина) Экспорт

	Элементы = Форма.Элементы;
	Объект = Форма.Объект;

	СтрокаТаблицы = Элементы[ИмяТаблицы].ТекущиеДанные;
	Если  ПересчитыватьСумму Тогда
		РассчитатьСуммуТабЧасти(СтрокаТаблицы, ЗначениеПустогоКоличества);
	КонецЕсли;
	
	Если СтрокаТаблицы.Свойство("СуммаНДС") Тогда
		РассчитатьСуммуНДСТабЧасти(СтрокаТаблицы, Объект.СуммаВключаетНДС, ПрименяютсяСтавки4и2);
	КонецЕсли;

	Если СтрокаТаблицы.Свойство("СуммаВРознице") Тогда
		СтрокаТаблицы.СуммаВРознице = СтрокаТаблицы.Количество * СтрокаТаблицы.ЦенаВРознице;
	КонецЕсли;

	Если СтрокаТаблицы.Свойство("Всего") Тогда
		СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма + ?(Объект.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	КонецЕсли;
	Если СтрокаТаблицы.Свойство("СуммаОтгрузки") И ПересчитыватьСумму Тогда
		СтрокаТаблицы.СуммаОтгрузки = СтрокаТаблицы.Сумма + ?(Объект.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	КонецЕсли;

КонецПроцедуры

Процедура ПриИзмененииСумма(Форма, ИмяТаблицы, ЗначениеПустогоКоличества = 0, ПрименяютсяСтавки4и2 = Ложь) Экспорт

	Элементы = Форма.Элементы;
	Объект = Форма.Объект;

	СтрокаТаблицы = Элементы[ИмяТаблицы].ТекущиеДанные;

	Если СтрокаТаблицы.Свойство("Количество") Тогда
		Если (СтрокаТаблицы.Количество = 0) И (ЗначениеПустогоКоличества = 0) Тогда
			СтрокаТаблицы.Цена = 0;
		Иначе
			СтрокаТаблицы.Цена = СтрокаТаблицы.Сумма / ?(СтрокаТаблицы.Количество = 0, ЗначениеПустогоКоличества, СтрокаТаблицы.Количество);
		КонецЕсли;
	КонецЕсли;

	Если СтрокаТаблицы.Свойство("СуммаНДС") Тогда
		РассчитатьСуммуНДСТабЧасти(СтрокаТаблицы, Объект.СуммаВключаетНДС, ПрименяютсяСтавки4и2);
	КонецЕсли;

	Если СтрокаТаблицы.Свойство("Всего") Тогда
		СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма + ?(Объект.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	КонецЕсли;
	Если СтрокаТаблицы.Свойство("СуммаОтгрузки") Тогда
		СтрокаТаблицы.СуммаОтгрузки = СтрокаТаблицы.Сумма + ?(Объект.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	КонецЕсли;

КонецПроцедуры

Процедура ПриИзмененииСтавкаНДС(Форма, ИмяТаблицы, ПрименяютсяСтавки4и2 = Ложь) Экспорт

	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	СтрокаТаблицы = Элементы[ИмяТаблицы].ТекущиеДанные;
	РассчитатьСуммуНДСТабЧасти(СтрокаТаблицы, Объект.СуммаВключаетНДС, ПрименяютсяСтавки4и2);
	Если СтрокаТаблицы.Свойство("Всего") Тогда
		СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма + ?(Объект.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	КонецЕсли;
	Если СтрокаТаблицы.Свойство("СуммаОтгрузки") Тогда
		СтрокаТаблицы.СуммаОтгрузки = СтрокаТаблицы.Сумма + ?(Объект.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	КонецЕсли;

КонецПроцедуры

Процедура ПриИзмененииСуммаНДС(Форма, ИмяТаблицы) Экспорт

	Элементы = Форма.Элементы;
	Объект = Форма.Объект;

	СтрокаТаблицы = Элементы[ИмяТаблицы].ТекущиеДанные;

	Если СтрокаТаблицы.Свойство("Всего") Тогда
		СтрокаТаблицы.Всего = СтрокаТаблицы.Сумма + ?(Объект.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	КонецЕсли;
	Если СтрокаТаблицы.Свойство("СуммаОтгрузки") Тогда
		СтрокаТаблицы.СуммаОтгрузки = СтрокаТаблицы.Сумма + ?(Объект.СуммаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	КонецЕсли;

КонецПроцедуры

// Рассчитывает сумму НДС исходя из суммы и флагов налогообложения
//
// Параметры: 
//  Сумма            - число, сумма от которой надо рассчитывать налоги, 
//  СуммаВключаетНДС - булево, признак включения НДС в сумму ("внутри" или "сверху"),
//  СтавкаНДС        - число , процентная ставка НДС,
//
// Возвращаемое значение:
//  Число, полученная сумма НДС
//
Функция РассчитатьСуммуНДС(Сумма, СуммаВключаетНДС, СтавкаНДС) Экспорт

	Если СуммаВключаетНДС Тогда
		СуммаБезНДС = 100 * Сумма / (100 + СтавкаНДС);
		СуммаНДС = Сумма - СуммаБезНДС;
	Иначе
		СуммаБезНДС = Сумма;
	КонецЕсли;

	Если НЕ СуммаВключаетНДС Тогда
		СуммаНДС = СуммаБезНДС * СтавкаНДС / 100;
	КонецЕсли;
	
	Возврат СуммаНДС;

КонецФункции // РассчитатьСуммуНДС()
