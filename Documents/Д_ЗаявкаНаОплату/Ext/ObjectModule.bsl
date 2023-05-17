﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
		
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		Возврат;	
	КонецЕсли;
	
	ОбновитьТЧПодчиненныхДокументов(); //Актуально для РСП
	СоздатьЗаписиВРегистреПрикрепленныхОбъектов();
	
	БПСервер.ДокументыСогласуемыеПриЗаписиОбработчик(ЭтотОбъект);
	сабОбщегоНазначения.сабПлатКалПриЗаписиОбъектовПриЗаписи(ЭтотОбъект, Отказ);
	
	РегистрыСведений.ВнутренниеДокументы.СоздатьЗаписьЖурнала(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Доступность = Ложь;
	ДатаОплаты = "";
	ИсполнительОплаты = "";
	
	ПодразделениеЦФО = ЦФО.ВидДеятельности;
	
	ЭтоСводныйРеестр = ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРеестраОплат.СводныйРеестрПлатежей");
	ЭтоОбщийРеестр = ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРеестраОплат.ОбщийРеестрПлатежей");

	Если ЭтоСводныйРеестр ИЛИ ЭтоОбщийРеестр Тогда
		Предприятие = Неопределено;
		Подразделение = Неопределено;
	КонецЕсли;
		
	Для каждого ТекСтрока Из ЗаявкаБезнал Цикл
		ТекСтрока.ОтменаОплаты = Ложь;		
		ТекСтрока.ПлатежноеПоручение = "";		
		ТекСтрока.Комментарии = "";
		ТекСтрока.Приложение = "";
		СтрокиРасшифровки = РасшифровкиСтрок.НайтиСтроки(Новый Структура("УИДСтрокиЗаявки", ТекСтрока.УИДСтроки));
		НовыйУИДСтроки = Новый УникальныйИдентификатор;
		Для каждого ТекСтрокаРасшифровки Из СтрокиРасшифровки Цикл
			ТекСтрокаРасшифровки.УИДСтрокиЗаявки = НовыйУИДСтроки;
			ТекСтрокаРасшифровки.Подразделение = ТекСтрокаРасшифровки.ЦФО.ВидДеятельности;
		КонецЦикла; 
		ТекСтрока.УИДСтроки = НовыйУИДСтроки;
		ТекСтрока.ЗаявкаНаФинансирование = "";
		
		ТекСтрока.ЗаявкаНаЗакупку = "";

		
		Если ЗначениеЗаполнено(ТекСтрока.БанковскийСчет) И ЗначениеЗаполнено(ТекСтрока.БанковскийСчет.ДатаЗакрытия) Тогда
			ТекСтрока.БанковскийСчет = "";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекСтрока.СчетКонтрагента) И ЗначениеЗаполнено(ТекСтрока.СчетКонтрагента.ДатаЗакрытия) Тогда
			ТекСтрока.СчетКонтрагента = "";
		КонецЕсли;
		
		ТекСтрока.УжеОплачено = 0;
		ТекСтрока.СуммаЧастичнойОплаты = 0;
		ТекСтрока.ЗаявленнаяСумма = 0;
		//ТекСтрока.Источник = "";
		
		Если ОбъектКопирования.ТипИсточника = ПредопределенноеЗначение("Перечисление.Д_ИсточникиСредств.БезНал") Тогда 	
			//ТекСтрока.Источник = "";
			//ТекСтрока.КПППлательщика = ТекСтрока.Организация.КПП;	
		Иначе
			ТекСтрока.Организация = "";
			ТекСтрока.БанковскийСчет = "";
		КонецЕсли;
		
		//ТекСтрока.Подразделение = ТекСтрока.ЦФО.ВидДеятельности;
		
	КонецЦикла;
	
	ТекущаяЗадача = "";
	ТекущийБизнесПроцесс = "";
	ОтложенныйСтарт = Ложь;
	Файл = "";
	Оповещения.Очистить();
	ОстаткиПоИсточникам.Очистить();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	//Если НЕ Самооплата И НЕ ТипИсточника = Перечисления.Д_ИсточникиСредств.Прочий И ПустаяСтрока(ИсполнительОплаты) Тогда
	//	ИсполнительОплаты = Справочники.Пользователи.СотрудникРКО1;	
	//КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;	
	КонецЕсли;

	СуммаДокумента = ЗаявкаБезнал.Итог("СуммаДДС");
	//Если Не ЗначениеЗаполнено(ДатаОплаты) Тогда
	//	ДатаОплаты = НачалоДня(Дата) + 24*3600;
	//КонецЕсли;
	ОплатыЧастичноОтменены = Ложь;
	
	Для каждого ТекСтрока Из ЗаявкаБезнал Цикл
		
		Если ТекСтрока.ОтменаОплаты Тогда
			ОплатыЧастичноОтменены = Истина;		
		КонецЕсли;
				
	КонецЦикла;
	
	Если ПометкаУдаления И НЕ БюджетныйНаСервере.РольАдминаДоступнаСервер() И НЕ БюджетныйНаСервере.РольДоступнаСервер("ОФК") Тогда
		
		Если БПСервер.СравнитьСтадию("Действие5", Ссылка) Тогда
			Отказ = Истина;	
		КонецЕсли;
		
		ТекБП = БПСервер.НайтиТекущийБПСервер(Ссылка);
		
		Если НЕ ТекБП = Неопределено Тогда
			
			Если ТекБП.Завершен И Не ТекБП.НеСогласовано Тогда
				Отказ = Истина;	
			КонецЕсли;
			
		КонецЕсли;
		
		Если Отказ Тогда
			Сообщить("Невозможно пометить на удаление оплаченную или находящуюся на стадии оплаты заявку.");
		КонецЕсли;	
		
	КонецЕсли;
	
	Если НЕ ДополнительныеСвойства.Свойство("Модифицирован") Тогда
		ДополнительныеСвойства.Вставить("Модифицирован", Ложь);
	КонецЕсли;
	
	//из подписки на событие
	БюджетныйНаСервере.ДокументыПередЗаписьюПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	БПСервер.ДокументыСогласуемыеПередЗаписьюПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	ВидСЗ = Справочники.Д_ВидыВнутреннихДокументов.ПолучитьЭлементПредопределенный("ЗаявкаНаОплату");
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Д_ИсточникППСрезПоследних.ОтветственноеЛицо КАК ОтветственноеЛицо,
	|	Д_ИсточникППСрезПоследних.БанковскиеСчета КАК Источник
	|ИЗ
	|	РегистрСведений.Д_ИсточникПП.СрезПоследних(&ДатаЗаявки, БанковскиеСчета В (&Источники)) КАК Д_ИсточникППСрезПоследних";
	
	Запрос.УстановитьПараметр("ДатаЗаявки", ?(Дата = '00010101', ТекущаяДата(), Дата));
	Запрос.УстановитьПараметр("Источники", ЗаявкаБезнал.ВыгрузитьКолонку("Источник"));
	
	Результат = Запрос.Выполнить();
	ВыборкаОтветственных = Результат.Выгрузить();
	
	ЭтоОбщийРегистр = ВидОперации = Перечисления.ВидыОперацийРеестраОплат.ОбщийРеестрПлатежей;
	
	Для каждого ТекСтрока Из ЗаявкаБезнал Цикл
		Если НЕ ВыборкаОтветственных.НайтиСтроки(Новый Структура("Источник", ТекСтрока.Источник)).Количество() Тогда
			сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(
			ЭтотОбъект,
			"Не назначен ответственый (исполнитель) по источнику.",
			"ЗаявкаБезнал",
			ЗаявкаБезнал.Индекс(ТекСтрока) + 1,
			?(ТипЗнч(ТекСтрока.Источник) = Тип("СправочникСсылка.БанковскиеСчета") И НЕ ЭтоОбщийРегистр, "БанковскийСчет", "Источник"),
			Отказ);
		КонецЕсли;
	КонецЦикла;
	
	//Если НЕ Предприятие.ЭтоГруппа И Предприятие.УчетПоПодразделениям И НЕ ЗначениеЗаполнено(Подразделение) Тогда
	//	Подразделение = Предприятие.ВидДеятельности;
		//сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(
		//ЭтотОбъект,
		//"Укажите подразделение.",
		//,
		//,
		//"Подразделение",
		//Отказ);
	//КонецЕсли;
	
	
	Если ВидОперации = Перечисления.ВидыОперацийРеестраОплат.СводныйРеестрПлатежей ИЛИ ВидОперации = Перечисления.ВидыОперацийРеестраОплат.ОбщийРеестрПлатежей Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Предприятие"));	
	КонецЕсли;
	
	
КонецПроцедуры

Функция СтатьяСырья(ТекСтатья)

	Возврат Ложь;	

КонецФункции // ()

Процедура ОбновитьТЧПодчиненныхДокументов()
	
	Запрос = новый Запрос;
	Запрос.УстановитьПараметр("ТЧ", ЗаявкаБезнал.Выгрузить(, "УИДСтроки, ПлатежноеПоручение"));
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТЧ.УИДСтроки,
	               |	ВЫРАЗИТЬ(ТЧ.ПлатежноеПоручение КАК Документ.ПлатежноеПоручение) КАК ПлатежноеПоручение
	               |ПОМЕСТИТЬ ВТ_ТЧ
	               |ИЗ
	               |	&ТЧ КАК ТЧ
	               |ГДЕ
	               |	ТЧ.ПлатежноеПоручение ССЫЛКА Документ.ПлатежноеПоручение
	               |	И НЕ ТЧ.ПлатежноеПоручение = ЗНАЧЕНИЕ(Документ.ПлатежноеПоручение.ПустаяСсылка)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_ТЧ.УИДСтроки,
	               |	ВТ_ТЧ.ПлатежноеПоручение КАК ПлатежноеПоручение
	               |ИЗ
	               |	ВТ_ТЧ КАК ВТ_ТЧ
	               |ГДЕ
	               |	НЕ ВТ_ТЧ.ПлатежноеПоручение.Номер ЕСТЬ NULL  //защита от <Объект не найден>
	               |ИТОГИ ПО
	               |	ПлатежноеПоручение";
	СписокУИДовПлатежкиДолженБыть = новый СписокЗначений;
	ВыборкаПлатежка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ПлатежноеПоручение");
	
	Пока ВыборкаПлатежка.Следующий() Цикл
		
		//сравним состав УИДов для текукщей платежки в заявке с тем, что уже записано в ТЧ СтрокиЗаявкиНаОплату

		СписокУИДовПлатежкиДолженБыть.Очистить();
		Выборка = ВыборкаПлатежка.Выбрать();
		Пока Выборка.Следующий() Цикл
			СписокУИДовПлатежкиДолженБыть.Добавить(Выборка.УИДСтроки);
		КонецЦикла;
		СписокУИДовПлатежкиДолженБыть.СортироватьПоЗначению();
		МассивУИДовПлатежкиДолженБыть = СписокУИДовПлатежкиДолженБыть.ВыгрузитьЗначения();
		МассивУИДовПлатежкиДолженБытьОднойСтрокой = ПолучитьСтрокуИзМассиваПодстрок(МассивУИДовПлатежкиДолженБыть);
		
		ТЧСтрокиЗаявкиНаОплату = ВыборкаПлатежка.ПлатежноеПоручение.СтрокиЗаявкиНаОплату; 
	    МассивУИДовПлатежкиВИБ = ТЧСтрокиЗаявкиНаОплату.ВыгрузитьКолонку("УИДСтрокиДокОснования");
		СписокУИДовПлатежкиВИБ = новый СписокЗначений;
		СписокУИДовПлатежкиВИБ.ЗагрузитьЗначения(МассивУИДовПлатежкиВИБ);
		СписокУИДовПлатежкиВИБ.СортироватьПоЗначению();
		МассивУИДовПлатежкиВИБ = СписокУИДовПлатежкиВИБ.ВыгрузитьЗначения();
		МассивУИДовПлатежкиВИБОднойСтрокой = ПолучитьСтрокуИзМассиваПодстрок(МассивУИДовПлатежкиВИБ);
		
		МассивыСовпадают = (МассивУИДовПлатежкиДолженБытьОднойСтрокой = МассивУИДовПлатежкиВИБОднойСтрокой);
		Если Не МассивыСовпадают Тогда
			ПлатежкаОбъект = ВыборкаПлатежка.ПлатежноеПоручение.ПолучитьОбъект(); 
			ПлатежкаОбъект.СтрокиЗаявкиНаОплату.Очистить();
			Для Каждого ТекСтрока Из МассивУИДовПлатежкиДолженБыть Цикл
				НоваяСтрока = ПлатежкаОбъект.СтрокиЗаявкиНаОплату.Добавить();
				НоваяСтрока.ДокОснование = Ссылка;
				НоваяСтрока.УИДСтрокиДокОснования = ТекСтрока;
			КонецЦикла;
			ПлатежкаОбъект.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает строку, полученную из массива элементов, разделенных символом разделителя
//
// Параметры:
//  Массив - Массив - массив элементов из которых необходимо получить строку
//  Разделитель - Строка - любой набор символов, который будет использован как разделитель между элементами в строке
//
// Возвращаемое значение:
//  Результат - Строка - строка, полученная из массива элементов, разделенных символом разделителя
// 
Функция ПолучитьСтрокуИзМассиваПодстрок(Массив, Разделитель = ",") Экспорт
	
	// возвращаемое значение функции
	Результат = "";
	
	Для Каждого Элемент ИЗ Массив Цикл
		
		Подстрока = ?(ТипЗнч(Элемент) = Тип("Строка"), Элемент, Строка(Элемент));
		
		РазделительПодстрок = ?(ПустаяСтрока(Результат), "", Разделитель);
		
		Результат = Результат + РазделительПодстрок + Подстрока;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура СоздатьЗаписиВРегистреПрикрепленныхОбъектов()
	
	НаборЗаписейПФРеестра = РегистрыСведений.ПрикрепленныеОбъекты.СоздатьНаборЗаписей();
	НаборЗаписейПФРеестра.Отбор.Владелец.Установить(Ссылка);
	НаборЗаписейПФРеестра.Прочитать();
	
	Если НЕ НаборЗаписейПФРеестра.Количество() Тогда
		
		Если Не РегистрыСведений.ПрикрепленныеОбъекты.ПроверитьВладельца(Ссылка) Тогда
			
			Для Каждого СтрокаЗаявки Из ЗаявкаБезнал Цикл
				
				Если ЗначениеЗаполнено(СтрокаЗаявки.Приложение) Тогда
					НоваяЗапись = НаборЗаписейПФРеестра.Добавить();
					НоваяЗапись.Владелец = Ссылка;
					НоваяЗапись.Объект	= СтрокаЗаявки.Приложение;
					НоваяЗапись.ВладелецИмяТЧ = "ЗаявкаБезнал";
					НоваяЗапись.ВладелецСтрокаТЧ = СтрокаЗаявки.НомерСтроки;
					НоваяЗапись.Автор	= сабОбщегоНазначения.ТекущийПользователь();
				КонецЕсли;
				
				Если ЗначениеЗаполнено(СтрокаЗаявки.ЗаявкаНаФинансирование) Тогда
					ФайлыЗаявкиНаФин = БПСервер.ПолучитьПрикрепленныеФайлыЗаявкиНаФинансирование(СтрокаЗаявки.ЗаявкаНаФинансирование);
					
					Для Каждого ТекФайлЗаявкиНаФин Из ФайлыЗаявкиНаФин Цикл
						НоваяЗапись = НаборЗаписейПФРеестра.Добавить();
						НоваяЗапись.Владелец = Ссылка;
						НоваяЗапись.Объект	= ТекФайлЗаявкиНаФин;
						НоваяЗапись.ВладелецИмяТЧ = "ЗаявкаБезнал";
						НоваяЗапись.ВладелецСтрокаТЧ = СтрокаЗаявки.НомерСтроки;
						НоваяЗапись.Автор	= сабОбщегоНазначения.ТекущийПользователь();
					КонецЦикла;
					
				КонецЕсли;
				
			КонецЦикла;
			
			НаборЗаписейПФРеестра.Записать();
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("ДатаГрафика") Тогда //формируем по графику платежей на дату
			
			Если ЗначениеЗаполнено(ДанныеЗаполнения.ВидОплаты) Тогда
				ТипИсточника = ?(ДанныеЗаполнения.ВидОплаты = Перечисления.ВидыОперацийДвиженияДС.КассовыйОрдер ИЛИ ДанныеЗаполнения.ВидОплаты = Перечисления.Д_ИсточникиСредств.Нал, Перечисления.Д_ИсточникиСредств.Нал, ?(ДанныеЗаполнения.ВидОплаты = Перечисления.ВидыОперацийДвиженияДС.Взаимозачет, Перечисления.Д_ИсточникиСредств.Казна,Перечисления.Д_ИсточникиСредств.БезНал));
				ВидОперации = Перечисления.ВидыОперацийРеестраОплат.СводныйРеестрПлатежей;
			Иначе
				ВидОперации = Перечисления.ВидыОперацийРеестраОплат.ОбщийРеестрПлатежей;
			КонецЕсли;
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
			               |	сабГрафикПлатежей.Документ КАК ЗаявкаНаФинансирование,
			               |	сабГрафикПлатежей.Предприятие КАК Предприятие,
			               |	сабГрафикПлатежей.ЦФО КАК ЦФО,
			               |	сабГрафикПлатежей.ПодразделениеЦФО КАК ПодразделениеЦФО,
			               |	сабГрафикПлатежей.ДатаПлатежа КАК ДатаПлатежа,
			               |	сабГрафикПлатежей.ВидОперации КАК ВидОперации,
			               |	сабГрафикПлатежей.Источник КАК БанковскийСчет,
			               |	сабГрафикПлатежей.Источник КАК Источник,
			               |	сабГрафикПлатежей.СтатьяДДС КАК СтатьяДДС,
			               |	сабГрафикПлатежей.СтавкаНДС КАК СтавкаНДС,
			               |	сабГрафикПлатежей.Контрагент КАК Контрагент,
			               |	сабГрафикПлатежей.Договор КАК Договор,
			               |	сабГрафикПлатежей.СчетКонтрагента КАК СчетКонтрагента,
			               |	сабГрафикПлатежей.Валюта КАК Валюта,
			               |	сабГрафикПлатежей.УИДСтрокиДокумента КАК УИДСтроки,
			               |	сабГрафикПлатежей.ТочкаМаршрута КАК ТочкаМаршрута,
			               |	сабГрафикПлатежей.Организация КАК Организация,
			               |	ВЫБОР
			               |		КОГДА сабГрафикПлатежей.Сумма < 0
			               |			ТОГДА -сабГрафикПлатежей.Сумма
			               |		ИНАЧЕ сабГрафикПлатежей.Сумма
			               |	КОНЕЦ КАК СуммаДДС,
			               |	ВЫБОР
			               |		КОГДА сабГрафикПлатежей.СуммаНДС < 0
			               |			ТОГДА -сабГрафикПлатежей.СуммаНДС
			               |		ИНАЧЕ сабГрафикПлатежей.СуммаНДС
			               |	КОНЕЦ КАК СуммаНДС,
			               |	ВЫБОР
			               |		КОГДА сабГрафикПлатежей.СуммаНДС < 0
			               |			ТОГДА -сабГрафикПлатежей.СуммаНДС
			               |		ИНАЧЕ сабГрафикПлатежей.СуммаНДС
			               |	КОНЕЦ КАК СуммаНДСАвтоматическийРасчет,
			               |	ВЫБОР
			               |		КОГДА сабГрафикПлатежей.ВалютнаяСумма < 0
			               |			ТОГДА -сабГрафикПлатежей.ВалютнаяСумма
			               |		ИНАЧЕ сабГрафикПлатежей.ВалютнаяСумма
			               |	КОНЕЦ КАК ВалютнаяСумма,
			               |	ВЫБОР
			               |		КОГДА сабГрафикПлатежей.ВалютнаяСуммаКонтрагента < 0
			               |			ТОГДА -сабГрафикПлатежей.ВалютнаяСуммаКонтрагента
			               |		ИНАЧЕ сабГрафикПлатежей.ВалютнаяСуммаКонтрагента
			               |	КОНЕЦ КАК ВалютнаяСуммаКонтрагента,
			               |	сабГрафикПлатежей.Курс КАК Курс,
			               |	сабГрафикПлатежей.НазначениеПлатежа КАК НазначениеПлатежаБух,
			               |	сабГрафикПлатежей.НазначениеПлатежаУчет КАК НазначениеПлатежа,
			               |	сабГрафикПлатежей.Комментарий КАК Примечание
			               |ИЗ
			               |	РегистрСведений.сабГрафикПлатежей КАК сабГрафикПлатежей
			               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Д_ЗаявкаНаОплату.ЗаявкаБезнал КАК Д_ЗаявкаНаОплатуЗаявкаБезнал
			               |		ПО сабГрафикПлатежей.Документ = Д_ЗаявкаНаОплатуЗаявкаБезнал.ЗаявкаНаФинансирование
			               |			И (Д_ЗаявкаНаОплатуЗаявкаБезнал.Ссылка.ПометкаУдаления = ЛОЖЬ)
			               |			И сабГрафикПлатежей.УИДСтрокиДокумента = Д_ЗаявкаНаОплатуЗаявкаБезнал.УИДСтроки
			               |ГДЕ
			               |	сабГрафикПлатежей.ДатаПлатежа <= &ДатаПлатежа
			               |	И (ТИПЗНАЧЕНИЯ(сабГрафикПлатежей.Документ) = ТИП(Документ.Д_ЗаявкаНаФинансирование)
			               |			ИЛИ ТИПЗНАЧЕНИЯ(сабГрафикПлатежей.Документ) = ТИП(Документ.Д_Бюджет))
			               |	И Д_ЗаявкаНаОплатуЗаявкаБезнал.Ссылка ЕСТЬ NULL
			               |	И сабГрафикПлатежей.Предприятие В ИЕРАРХИИ(&ДоступныеПредприятия)
			               |	И ВЫБОР
			               |			КОГДА &ТипИсточника = ЗНАЧЕНИЕ(Перечисление.Д_ИсточникиСредств.ПустаяСсылка)
			               |				ТОГДА ИСТИНА
			               |			ИНАЧЕ сабГрафикПлатежей.Документ.ТипИсточника = &ТипИсточника
			               |		КОНЕЦ
			               |	И сабГрафикПлатежей.ОснованиеПометкаУдаления = ЛОЖЬ
			               |	И сабГрафикПлатежей.Документ.ПометкаУдаления = ЛОЖЬ
			               |	И (сабГрафикПлатежей.Сценарий = ЗНАЧЕНИЕ(Справочник.СценарииПланирования.ПустаяСсылка)
			               |			ИЛИ &ПоказыватьГрафикПоБюджету)
			               |	И ВЫБОР
			               |			КОГДА НЕОПРЕДЕЛЕНО В (&МассивДоков)
			               |				ТОГДА ИСТИНА
			               |			ИНАЧЕ сабГрафикПлатежей.Документ В (&МассивДоков)
			               |		КОНЕЦ
			               |	И сабГрафикПлатежей.ВидОперации В(&ВидыОперацийРасходов)
			               |	И (сабГрафикПлатежей.Сценарий = ЗНАЧЕНИЕ(Справочник.СценарииПланирования.ПустаяСсылка)
			               |			ИЛИ сабГрафикПлатежей.Сценарий = &СценарийФакт)
			               |
			               |УПОРЯДОЧИТЬ ПО
			               |	Предприятие,
			               |	Источник
			               |АВТОУПОРЯДОЧИВАНИЕ";
			
			Запрос.УстановитьПараметр("ДатаПлатежа", КонецДня(ДанныеЗаполнения.ДатаГрафика));
			Запрос.УстановитьПараметр("ТипИсточника", ТипИсточника);
			//Запрос.УстановитьПараметр("РежимОплаты", ДанныеЗаполнения.РежимРаботы);
			Запрос.УстановитьПараметр("ПоказыватьГрафикПоБюджету", ?(ДанныеЗаполнения.Свойство("ПоказыватьГрафикПоБюджету"), ДанныеЗаполнения.ПоказыватьГрафикПоБюджету, Истина));
			Запрос.УстановитьПараметр("ДоступныеПредприятия", ПараметрыСеанса.ДоступныеПредприятия);
			Запрос.УстановитьПараметр("МассивДоков", ?(ДанныеЗаполнения.Свойство("МассивДоков"), ДанныеЗаполнения.МассивДоков, Неопределено));
			Запрос.УстановитьПараметр("ВидыОперацийРасходов", ПП_Сервер.ЭтоРасходнаяОперация());
			Запрос.УстановитьПараметр("СценарийФакт", Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина));
			
			Результат = Запрос.Выполнить();
			Выборка = Результат.Выбрать();
			
			МассивПредприятий = Новый Массив;
			
			ТипыИсточников = Новый Массив;
			
			Пока Выборка.Следующий() Цикл
				
				Если МассивПредприятий.Найти(Выборка.Предприятие) = Неопределено Тогда
					МассивПредприятий.Добавить(Выборка.Предприятие);				
				КонецЕсли;
				НоваяСтрока = ЗаявкаБезнал.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка.ЗаявкаНаФинансирование);
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
				Если ТипЗнч(НоваяСтрока.Источник) = Тип("СправочникСсылка.БанковскиеСчета") И Не ЗначениеЗаполнено(НоваяСтрока.Организация) Тогда
					НоваяСтрока.Организация = НоваяСтрока.Источник.Владелец;				
				КонецЕсли;
				НоваяСтрока.НазначениеПлатежа = Выборка.НазначениеПлатежа;
				НоваяСтрока.НазначениеПлатежаБух = Документы.Д_ЗаявкаНаОплату.СформироватьНазначениеДляУчета(НоваяСтрока.НазначениеПлатежаБух);
				Если НЕ ЗначениеЗаполнено(НоваяСтрока.НазначениеПлатежа) Тогда
					НоваяСтрока.НазначениеПлатежа = НоваяСтрока.НазначениеПлатежаБух;				
				КонецЕсли;
				Если НЕ ЗначениеЗаполнено(НоваяСтрока.НазначениеПлатежаБух) Тогда
					НоваяСтрока.НазначениеПлатежаБух = НоваяСтрока.НазначениеПлатежа;				
				КонецЕсли;
				
				Если ТипыИсточников.Найти(ТипЗнч(НоваяСтрока.Источник)) = Неопределено Тогда
					ТипыИсточников.Добавить(ТипЗнч(НоваяСтрока.Источник));				
				КонецЕсли;
				
			КонецЦикла;
			
			Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения.ВидОплаты) Тогда
				Если ТипыИсточников.Количество() > 1 Тогда
					ТипИсточника = Перечисления.Д_ИсточникиСредств.Прочий;
				ИначеЕсли ТипыИсточников.Количество() = 1 Тогда
					Если ТипыИсточников[0] = Тип("СправочникСсылка.Кассы") Тогда
						ТипИсточника = Перечисления.Д_ИсточникиСредств.Нал;
					Иначе
						ТипИсточника = Перечисления.Д_ИсточникиСредств.БезНал;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			Если ВидОперации = Перечисления.ВидыОперацийРеестраОплат.ОбщийРеестрПлатежей ИЛИ ВидОперации = Перечисления.ВидыОперацийРеестраОплат.СводныйРеестрПлатежей Тогда
				Запрос = Новый Запрос;
				Запрос.Текст = "ВЫБРАТЬ
				|	Предприятия.Родитель КАК Родитель,
				|	Предприятия.Ссылка КАК Ссылка
				|ИЗ
				|	Справочник.Предприятия КАК Предприятия
				|ГДЕ
				|	Предприятия.Ссылка В(&Предприятия)
				|
				|СГРУППИРОВАТЬ ПО
				|	Предприятия.Родитель,
				|	Предприятия.Ссылка";
				
				Запрос.УстановитьПараметр("Предприятия", МассивПредприятий);
				
				Результат = Запрос.Выполнить();
				Выборка = Результат.Выгрузить();
				
				Если Выборка.Количество() = 1 Тогда
					Предприятие = Выборка[0].Ссылка;
				Иначе
					Выборка.Свернуть("Родитель");
					Если Выборка.Количество() = 1 Тогда
						Предприятие = Выборка[0].Родитель;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			//заполняем остатки по данным ПК
			Если ДанныеЗаполнения.Свойство("ДанныеТЗ") Тогда
				Для каждого ТекСтрока Из ЗаявкаБезнал Цикл
					Если ЗначениеЗаполнено(ТекСтрока.Источник) И НЕ ОстаткиПоИсточникам.НайтиСтроки(Новый Структура("Источник", ТекСтрока.Источник)).Количество() Тогда
						НоваяСтрока = ОстаткиПоИсточникам.Добавить();
						НоваяСтрока.Источник = ТекСтрока.Источник;
						Для каждого ТекНайденнаяСтрока Из ДанныеЗаполнения.ДанныеТЗ Цикл
							Если ТекНайденнаяСтрока.Источник = ТекСтрока.Источник И ТекНайденнаяСтрока.СтатьяДДС = "Остаток на начало" Тогда
								НоваяСтрока.Сумма = ТекНайденнаяСтрока.ОстатокНаНачалоРабочий;	
							КонецЕсли;
						КонецЦикла; 
						СтрокиРасхода = ЗаявкаБезнал.НайтиСтроки(Новый Структура("Источник", ТекСтрока.Источник)); 
						НоваяСтрока.СуммаРасход = 0;
						Для каждого ТекНайденнаяСтрока Из СтрокиРасхода Цикл
							НоваяСтрока.СуммаРасход = НоваяСтрока.СуммаРасход + ТекНайденнаяСтрока.СуммаДДС;	
						КонецЦикла;
						НоваяСтрока.СуммаПриход = 0;
						Для каждого ТекНайденнаяСтрока Из ДанныеЗаполнения.ДанныеТЗ Цикл
							Если ТекНайденнаяСтрока.Источник = ТекСтрока.Источник И ТипЗнч(ТекНайденнаяСтрока.СтатьяДДС) = Тип("СправочникСсылка.СтатьиДвиженияДенежныхСредств") И ТекНайденнаяСтрока.СтатьяДДС.Доход Тогда
								НоваяСтрока.СуммаПриход = НоваяСтрока.СуммаПриход + ТекНайденнаяСтрока.День0 + ТекНайденнаяСтрока.Просрочено;
							КонецЕсли;
						КонецЦикла; 
						НоваяСтрока.ОстатокНаКонец = НоваяСтрока.Сумма + НоваяСтрока.СуммаПриход - НоваяСтрока.СуммаРасход;
					КонецЕсли;	
				КонецЦикла;
				ОстаткиПоИсточникам.Сортировать("Источник");
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	БюджетныйНаСервере.ПриУстановкеНовогоНомераПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
КонецПроцедуры

