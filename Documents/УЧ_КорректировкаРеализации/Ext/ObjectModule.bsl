﻿Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Учетный.Записывать = Истина;
	
	СоответствиеСчета = ПоучитьСоответствияСчетовНоменклатуры();
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	СценарийФайт = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
	
	РаспределятьПроводкиПоДокументамТоварооборота = Предприятие.УчетнаяПолитика.РаспределятьПроводкиПоДокументамТоварооборота;
	
	СтруктураИмен = УЧ_Сервер.СформироватьСтруктуруИмен(ЭтотОбъект);
	СтруктураСоответствий = УЧ_Сервер.ПоучитьСоответствияСчетовНоменклатуры(ЭтотОбъект, СтруктураИмен);
	ТаблицаОстатков = УЧ_Сервер.ПолучитьТаблицуОстатков(ЭтотОбъект, СтруктураИмен, СтруктураСоответствий);
	РезультатОстатки = ТаблицаОстатков.РезультатОстатки;
	СоответствиеУчетаПоПодразделениям = СтруктураСоответствий.СоответствияУчетаПодразделений;
	Для Каждого ТекСтрокаТабличнаяЧасть Из Товары Цикл
		
		Если ТекСтрокаТабличнаяЧасть.Сумма - ТекСтрокаТабличнаяЧасть.СуммаДоИзменения = 0 И ТекСтрокаТабличнаяЧасть.Количество - ТекСтрокаТабличнаяЧасть.КоличествоДоИзменения = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если  НЕ ТекСтрокаТабличнаяЧасть.Количество - ТекСтрокаТабличнаяЧасть.КоличествоДоИзменения = 0 Тогда
			Движение = Движения.Учетный.Добавить();
			СтатьяСебестоимость = Справочники.СтатьиЗатрат.НайтиПоКоду("2500.01");
			//СчКредит = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.Счет), ТекСтрокаТабличнаяЧасть.Счет, УЧ_Сервер.СчетПоКоду("10.05"));;
			
			СчетГП = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.Счет), ТекСтрокаТабличнаяЧасть.Счет, СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Номенклатура));
			УчетПоподразделениямСчетУчета = СоответствиеУчетаПоПодразделениям.Получить(СчетГП);
			
			Если ТекСтрокаТабличнаяЧасть.Количество - ТекСтрокаТабличнаяЧасть.КоличествоДоИзменения > 0 Тогда
				КоличествоИтого = ТекСтрокаТабличнаяЧасть.Количество - ТекСтрокаТабличнаяЧасть.КоличествоДоИзменения;
				Увеличение = Истина;
			ИначеЕсли ТекСтрокаТабличнаяЧасть.Количество - ТекСтрокаТабличнаяЧасть.КоличествоДоИзменения < 0 Тогда
				КоличествоИтого = ТекСтрокаТабличнаяЧасть.КоличествоДоИзменения-ТекСтрокаТабличнаяЧасть.Количество;
				Увеличение = Ложь;
			 КонецЕсли;
			
			//себестоимость
			Если УчетПоподразделениямСчетУчета Тогда
				СтруктураПоиска = Новый Структура("Номенклатура, Склад, Счет, Подразделение", ТекСтрокаТабличнаяЧасть.Номенклатура, ТекСтрокаТабличнаяЧасть.Склад, СчетГП, Подразделение);
			Иначе	
				СтруктураПоиска = Новый Структура("Номенклатура, Склад, Счет", ТекСтрокаТабличнаяЧасть.Номенклатура, ТекСтрокаТабличнаяЧасть.Склад, СчетГП);
			КонецЕсли;
			ВыборкаДетальныеЗаписи = РезультатОстатки.НайтиСтроки(СтруктураПоиска);
			Если ВыборкаДетальныеЗаписи.Количество() Тогда
				Себестоимость = ?(ВыборкаДетальныеЗаписи[0].Количество = КоличествоИтого И НЕ Увеличение, ВыборкаДетальныеЗаписи[0].Сумма, ВыборкаДетальныеЗаписи[0].Цена*КоличествоИтого);
			Иначе
				Себестоимость = 0;
			КонецЕсли;

			Движение.СценарийПлана = СценарийФайт;
			Движение.Предприятия = Предприятие;
			Движение.Период = Дата;
			Движение.СчетДт =ПланыСчетов.Учетный.Счет9002() ;
			Если УчетПоподразделениямСчетУчета Тогда
				Движение.ПодразделениеДт = Подразделение;
			КонецЕсли;
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 1, ТекСтрокаТабличнаяЧасть.Номенклатура);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 2, СтатьяСебестоимость);
			Движение.СчетКт = СчетГП;
			
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 1, ТекСтрокаТабличнаяЧасть.Номенклатура);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 2, ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.Склад), ТекСтрокаТабличнаяЧасть.Склад, Склад));
			
			//++сабОпер
			Если НЕ Движение.СчетКт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Документ", Истина)) = Неопределено И РаспределятьПроводкиПоДокументамТоварооборота Тогда
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 3, Ссылка);
			КонецЕсли;
			//--сабОпер
			Если УчетПоподразделениямСчетУчета Тогда
				Движение.ПодразделениеКт = Подразделение;
			КонецЕсли;
			Если ФлагВалюты Тогда
				Движение.ВалютнаяСуммаКт = ТекСтрокаТабличнаяЧасть.Сумма; 
				Движение.ВалютаКт = Валюта;
			КонецЕсли;
			
			//Писать тупо сумму не совсем правильно (ндс может быть не в сумме), но оставил как есть, чтобы поступления и корр работали по 1 алгоритму
			Движение.КоличествоКт = ?(Увеличение, КоличествоИтого, -КоличествоИтого) ;
			Движение.Сумма = ?(Увеличение, Себестоимость, -Себестоимость) ; //ТекСтрокаТабличнаяЧасть.Сумма - ТекСтрокаТабличнаяЧасть.СуммаДоИзменения;
			
			Движение.НомерСтрокиДок = ТекСтрокаТабличнаяЧасть.НомерСтроки;
			Движение.Содержание = Комментарий;
		КонецЕсли;
		
		Движение = Движения.Учетный.Добавить();
		
		СчДебет = ТекСтрокаТабличнаяЧасть.Счет;
		СтатьяВыручка = Справочники.СтатьиЗатрат.НайтиПоНаименованию("Выручка от реализации", Истина);
		Движение.СценарийПлана = СценарийФайт;
		Движение.Предприятия = Предприятие;
		Движение.Период = Дата;
		Движение.СчетДт = СчетКонтрагента;
		//Если СчДебет.УчетПоПодразделениям Тогда
		//	Движение.ПодразделениеДт = Подразделение;
		//КонецЕсли;
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 1, Контрагент);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 2, Договор);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 3, ДокОснование);
		
		СчетГП = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.Счет), ТекСтрокаТабличнаяЧасть.Счет, СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Номенклатура));
		УчетПоподразделениямСчетУчета = СоответствиеУчетаПоПодразделениям.Получить(СчетГП);


		Движение.СчетКт = ПланыСчетов.Учетный.Счет9001();
		
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 1, ТекСтрокаТабличнаяЧасть.Номенклатура);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 2, СтатьяВыручка);
		
		//++сабОпер
		Если НЕ Движение.СчетКт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Документ", Истина)) = Неопределено И РаспределятьПроводкиПоДокументамТоварооборота Тогда
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 3, Ссылка);
		КонецЕсли;
		//--сабОпер
		Если УчетПоподразделениямСчетУчета Тогда
			Движение.ПодразделениеКт = Подразделение; 
		КонецЕсли;	
		Если ФлагВалюты Тогда
			Движение.ВалютнаяСуммаКт = ТекСтрокаТабличнаяЧасть.Сумма; 
			Движение.ВалютаКт = Валюта;
		КонецЕсли;
		
		//Писать тупо сумму не совсем правильно (ндс может быть не в сумме), но оставил как есть, чтобы поступления и корр работали по 1 алгоритму
		Движение.КоличествоКт = ТекСтрокаТабличнаяЧасть.Количество - ТекСтрокаТабличнаяЧасть.КоличествоДоИзменения;
		Движение.Сумма = ТекСтрокаТабличнаяЧасть.Сумма - ТекСтрокаТабличнаяЧасть.СуммаДоИзменения;
		
		Движение.НомерСтрокиДок = ТекСтрокаТабличнаяЧасть.НомерСтроки;
		Движение.Содержание = Комментарий;

	КонецЦикла;
	
	Для Каждого ТекСтрокаТабличнаяЧасть Из Услуги Цикл
		
		Если ТекСтрокаТабличнаяЧасть.Сумма - ТекСтрокаТабличнаяЧасть.СуммаДоИзменения = 0 И ТекСтрокаТабличнаяЧасть.Количество - ТекСтрокаТабличнаяЧасть.КоличествоДоИзменения = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Движение = Движения.Учетный.Добавить();
		
		СчДебет = ТекСтрокаТабличнаяЧасть.СчетДоходов;
		СтатьяВыручка = Справочники.СтатьиЗатрат.НайтиПоНаименованию("Выручка от реализации", Истина);
		Движение.СценарийПлана = СценарийФайт;
		Движение.Предприятия = Предприятие;
		Движение.Период = Дата;
		Движение.СчетДт = СчетКонтрагента;
		//Если СчДебет.УчетПоПодразделениям Тогда
		//	Движение.ПодразделениеДт = Подразделение;
		//КонецЕсли;
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 1, Контрагент);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 2, Договор);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 3, ДокОснование);
		
		СчетГП = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.Счет), ТекСтрокаТабличнаяЧасть.Счет, СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Номенклатура));
		УчетПоподразделениямСчетУчета = СоответствиеУчетаПоПодразделениям.Получить(СчетГП);


		Движение.СчетКт = ПланыСчетов.Учетный.Счет9001();
		
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 1, ТекСтрокаТабличнаяЧасть.Номенклатура);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 2, СтатьяВыручка);
		
		//++сабОпер
		Если НЕ Движение.СчетКт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Документ", Истина)) = Неопределено И РаспределятьПроводкиПоДокументамТоварооборота Тогда
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 3, Ссылка);
		КонецЕсли;
		//--сабОпер
		Если УчетПоподразделениямСчетУчета Тогда
			Движение.ПодразделениеКт = Подразделение; 
		КонецЕсли;	
		Если ФлагВалюты Тогда
			Движение.ВалютнаяСуммаКт = ТекСтрокаТабличнаяЧасть.Сумма; 
			Движение.ВалютаКт = Валюта;
		КонецЕсли;
		
		//Писать тупо сумму не совсем правильно (ндс может быть не в сумме), но оставил как есть, чтобы поступления и корр работали по 1 алгоритму
		Движение.КоличествоКт = ТекСтрокаТабличнаяЧасть.Количество - ТекСтрокаТабличнаяЧасть.КоличествоДоИзменения;
		Движение.Сумма = ТекСтрокаТабличнаяЧасть.Сумма - ТекСтрокаТабличнаяЧасть.СуммаДоИзменения;
		
		Движение.НомерСтрокиДок = ТекСтрокаТабличнаяЧасть.НомерСтроки;
		Движение.Содержание = Комментарий;

			
		
				
	КонецЦикла;
	
	сабОперОбщегоНазначения.РаспределитьПроводкиПоДокументамОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведенияДокумента)
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	РучнаяКорректировка = Ложь;
	Движения.Записать();
	
КонецПроцедуры


Функция ПоучитьСоответствияСчетовНоменклатуры()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	УЧ_КорректировкаРеализацииТовары.Номенклатура КАК Номенклатура,
	               |	ВЫБОР
	               |		КОГДА УЧ_КорректировкаРеализацииТовары.Номенклатура.Счет10 = ЗНАЧЕНИЕ(ПланСчетов.Учетный.ПустаяСсылка)
	               |			ТОГДА &Счет41
	               |		ИНАЧЕ УЧ_КорректировкаРеализацииТовары.Номенклатура.Счет10
	               |	КОНЕЦ КАК Счет
	               |ИЗ
	               |	Документ.УЧ_КорректировкаРеализации.Товары КАК УЧ_КорректировкаРеализацииТовары
	               |ГДЕ
	               |	УЧ_КорректировкаРеализацииТовары.Ссылка = &Ссылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	УЧ_КорректировкаРеализацииТовары.Номенклатура,
	               |	ВЫБОР
	               |		КОГДА УЧ_КорректировкаРеализацииТовары.Номенклатура.Счет10 = ЗНАЧЕНИЕ(ПланСчетов.Учетный.ПустаяСсылка)
	               |			ТОГДА &Счет41
	               |		ИНАЧЕ УЧ_КорректировкаРеализацииТовары.Номенклатура.Счет10
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
	Возврат Соответствия;	
	
КонецФункции // ()

Процедура ПриКопировании(ОбъектКопирования)
	
	РучнаяКорректировка = Ложь;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	//из подписки на событие
	БюджетныйНаСервере.ДокументыПередЗаписьюПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтотОбъект.ЭтоНовый());
	
	СуммаИтог = Товары.Итог("Сумма");
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	БюджетныйНаСервере.ПриУстановкеНовогоНомераПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
			
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УЧ_Реализация") Тогда
		
		ДокОснование = ДанныеЗаполнения;
		Документы.УЧ_КорректировкаРеализации.ЗаполнитьПоДокументуОснованию(ЭтотОбъект);
		
	КонецЕсли;
	
	сабОбщегоНазначенияБУХ.сабОбработкиЗаполненияУчпетныхДокументовОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ОбработкаЗаполненияСФормы(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт

	ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);	

КонецПроцедуры
