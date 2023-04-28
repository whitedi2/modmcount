﻿Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Учетный.Записывать = Истина;
	
	СоответствиеСчета = ПоучитьСоответствияСчетовНоменклатуры();
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	СценарийФакт = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
	
	РаспределятьПроводкиПоДокументамТоварооборота = Предприятие.УчетнаяПолитика.РаспределятьПроводкиПоДокументамТоварооборота;
	
	Для Каждого ТекСтрокаТабличнаяЧасть Из Товары Цикл
		
		Если ТекСтрокаТабличнаяЧасть.Сумма - ТекСтрокаТабличнаяЧасть.СуммаДоИзменения = 0 И ТекСтрокаТабличнаяЧасть.Количество - ТекСтрокаТабличнаяЧасть.КоличествоДоИзменения = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Движение = Движения.Учетный.Добавить();
		
		СчДебет = СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Номенклатура);
		
		Движение.СценарийПлана = СценарийФакт;
		Движение.Предприятия = Предприятие;
		Движение.Период = Дата;
		Движение.СчетДт = СчДебет;
		Если СчДебет.УчетПоПодразделениям Тогда
			Движение.ПодразделениеДт = Подразделение;
		КонецЕсли;
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 1, ТекСтрокаТабличнаяЧасть.Номенклатура);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 2, ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.Склад), ТекСтрокаТабличнаяЧасть.Склад, Склад));
		Движение.СчетКт = СчетКонтрагента;
		
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 1, Контрагент);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 2, Договор);
		
		//++сабОпер
		Если НЕ Движение.СчетКт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Документ", Истина)) = Неопределено И РаспределятьПроводкиПоДокументамТоварооборота Тогда
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 3, Ссылка);
		КонецЕсли;
		//--сабОпер
		
		Если СчетКонтрагента.УчетПоПодразделениям Тогда
			Движение.ПодразделениеКт = Подразделение; 
		КонецЕсли;
		
		Если ФлагВалюты Тогда
			Движение.ВалютнаяСуммаКт = ТекСтрокаТабличнаяЧасть.Сумма; 
			Движение.ВалютаКт = Валюта;
		КонецЕсли;
		
		//Писать тупо сумму не совсем правильно (ндс может быть не в сумме), но оставил как есть, чтобы поступления и корр работали по 1 алгоритму
		Движение.КоличествоДт = ТекСтрокаТабличнаяЧасть.Количество - ТекСтрокаТабличнаяЧасть.КоличествоДоИзменения;
		Движение.Сумма = ТекСтрокаТабличнаяЧасть.Сумма - ТекСтрокаТабличнаяЧасть.СуммаДоИзменения;
		
		Движение.НомерСтрокиДок = ТекСтрокаТабличнаяЧасть.НомерСтроки;
		Движение.Содержание = Комментарий;
			
	КонецЦикла;
	
	Для Каждого ТекСтрокаТабличнаяЧасть Из Услуги Цикл
		
		Если ТекСтрокаТабличнаяЧасть.Сумма - ТекСтрокаТабличнаяЧасть.СуммаДоИзменения = 0 И ТекСтрокаТабличнаяЧасть.Количество - ТекСтрокаТабличнаяЧасть.КоличествоДоИзменения = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Движение = Движения.Учетный.Добавить();
		
		Движение.СценарийПлана = СценарийФакт;
		Движение.Предприятия = Предприятие;
		Движение.Период = Дата;
		Движение.СчетДт = ТекСтрокаТабличнаяЧасть.СчетЗатрат;
		Если Движение.СчетДт.УчетПоПодразделениям Тогда
			Движение.ПодразделениеДт = Подразделение;
		КонецЕсли;
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 1, ТекСтрокаТабличнаяЧасть.Субконто1);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 2, ТекСтрокаТабличнаяЧасть.Субконто2);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 3, ТекСтрокаТабличнаяЧасть.Субконто3);
		Движение.СчетКт = СчетКонтрагента;
		
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 1, Контрагент);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 2, Договор);
		
		//++сабОпер
		Если НЕ Движение.СчетКт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Документ", Истина)) = Неопределено И РаспределятьПроводкиПоДокументамТоварооборота Тогда
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 3, Ссылка);
		КонецЕсли;
		//--сабОпер
		
		Если СчетКонтрагента.УчетПоПодразделениям Тогда
			Движение.ПодразделениеКт = Подразделение; 
		КонецЕсли;
		
		Если ФлагВалюты Тогда
			Движение.ВалютнаяСуммаКт = ТекСтрокаТабличнаяЧасть.Сумма; 
			Движение.ВалютаКт = Валюта;
		КонецЕсли;
		
		//Писать тупо сумму не совсем правильно (ндс может быть не в сумме), но оставил как есть, чтобы поступления и корр работали по 1 алгоритму
		//Движение.КоличествоДт = ТекСтрокаТабличнаяЧасть.Количество - ТекСтрокаТабличнаяЧасть.КоличествоДоИзменения;
		Движение.Сумма = ТекСтрокаТабличнаяЧасть.Сумма - ТекСтрокаТабличнаяЧасть.СуммаДоИзменения;
		
		Движение.НомерСтрокиДок = ТекСтрокаТабличнаяЧасть.НомерСтроки;
		Движение.Содержание = Комментарий;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	РучнаяКорректировка = Ложь;
	Движения.Записать();
	
КонецПроцедуры

Функция ПоучитьСоответствияСчетовНоменклатуры()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	УЧ_КорректировкаПоступленияТовары.Номенклатура КАК Номенклатура,
	               |	ВЫБОР
	               |		КОГДА УЧ_КорректировкаПоступленияТовары.Номенклатура.Счет10 = ЗНАЧЕНИЕ(ПланСчетов.Учетный.ПустаяСсылка)
	               |			ТОГДА &Счет41
	               |		ИНАЧЕ УЧ_КорректировкаПоступленияТовары.Номенклатура.Счет10
	               |	КОНЕЦ КАК Счет
	               |ИЗ
	               |	Документ.УЧ_КорректировкаПоступления.Товары КАК УЧ_КорректировкаПоступленияТовары
	               |ГДЕ
	               |	УЧ_КорректировкаПоступленияТовары.Ссылка = &Ссылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	УЧ_КорректировкаПоступленияТовары.Номенклатура,
	               |	ВЫБОР
	               |		КОГДА УЧ_КорректировкаПоступленияТовары.Номенклатура.Счет10 = ЗНАЧЕНИЕ(ПланСчетов.Учетный.ПустаяСсылка)
	               |			ТОГДА &Счет41
	               |		ИНАЧЕ УЧ_КорректировкаПоступленияТовары.Номенклатура.Счет10
	               |	КОНЕЦ";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Счет41", ПланыСчетов.Учетный.Счет41());
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	
	Соответствия = Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		Соответствия.Вставить(Выборка.Номенклатура, Выборка.Счет);
	КонецЦикла;
	Соответствия.Вставить(Неопределено, ПланыСчетов.Учетный.Счет41());
	Соответствия.Вставить(Null, ПланыСчетов.Учетный.Счет41());
	Соответствия.Вставить(Справочники.Номенклатура.ПустаяСсылка(), ПланыСчетов.Учетный.Счет41());
	
	МассивМатериаловБезСчета = Новый Массив;
	Для каждого ТекСтрока Из Товары Цикл
		Если МассивМатериаловБезСчета.Найти(ТекСтрока["Номенклатура"]) = Неопределено Тогда
			МассивМатериаловБезСчета.Добавить(ТекСтрока["Номенклатура"]);	
		КонецЕсли;
	КонецЦикла;
	
	НовоеСоответствие = сабОбщегоНазначения.ПолучитьСчетУчетаНоменклатуры(МассивМатериаловБезСчета, Организация, Неопределено);
	Для каждого ТекСоотв Из НовоеСоответствие Цикл
		Если ЗначениеЗаполнено(ТекСоотв.Значение.СчетУчетаУУ) Тогда
			Соответствия.Вставить(ТекСоотв.Ключ, ТекСоотв.Значение.СчетУчетаУУ);
			//СоответствияУчетаПодразделений.Вставить(ТекСоотв.Значение.СчетУчетаУУ, ТекСоотв.Значение.СчетУчетаУУ.УчетПоПодразделениям);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Соответствия;	
	
КонецФункции // ()

Процедура ПриКопировании(ОбъектКопирования)
	
	РучнаяКорректировка = Ложь;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	//из подписки на событие
	БюджетныйНаСервере.ДокументыПередЗаписьюПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтотОбъект.ЭтоНовый());
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	БюджетныйНаСервере.ПриУстановкеНовогоНомераПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УЧ_ПоступлениеТоваров") Тогда
		
		ДокОснование = ДанныеЗаполнения;
		Документы.УЧ_КорректировкаПоступления.ЗаполнитьПоДокументуОснованию(ЭтотОбъект);
		
	КонецЕсли;
	
	сабОбщегоНазначенияБУХ.сабОбработкиЗаполненияУчпетныхДокументовОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ОбработкаЗаполненияСФормы(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт

	ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);	

КонецПроцедуры
