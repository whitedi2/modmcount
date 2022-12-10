﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	
	СтатьяФормальнаяСебестоимость = Справочники.СтатьиЗатрат.НайтиПоНаименованию("Формальная себестоимость", Истина);;
	СтатьяКорректировкиПартУчета  = Справочники.СтатьиЗатрат.НайтиПоНаименованию("Корректировки партионного учета", Истина);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	РаспределятьПроводкиПоДокументамТоварооборота = Предприятие.УчетнаяПолитика.РаспределятьПроводкиПоДокументамТоварооборота;
	
	Движения.Учетный.Записывать = Истина;
	
	СтруктураИмен = УЧ_Сервер.СформироватьСтруктуруИмен(ЭтотОбъект);
	
	СтруктураСоответствий = УЧ_Сервер.ПоучитьСоответствияСчетовНоменклатуры(ЭтотОбъект, СтруктураИмен);
	СоответствиеСчета = СтруктураСоответствий.Соответствия;
	СоответствиеУчетаПоПодразделениям = СтруктураСоответствий.СоответствияУчетаПодразделений;
	
	//СубконтоПроизвольное = ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Документ", Истина);
	//СубконтоКонтрагенты = ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Контрагенты", Истина);
	//СубконтоДоговорыКонтрагентов = ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Договоры", Истина);
	//СчетТовары = ПланыСчетов.Учетный.Счет41();
	//Счет1009 = ПланыСчетов.Учетный._10_09;
	//КонтрагентПроект = ?(ТипЗнч(Контрагент) = Тип("СправочникСсылка.Контрагенты"), Контрагент.Проект, Контрагент);
	
	ТаблицаОстатков = УЧ_Сервер.ПолучитьТаблицуОстатков(ЭтотОбъект, СтруктураИмен, СтруктураСоответствий);
	РезультатОстатки = ТаблицаОстатков.РезультатОстатки;
	РезультатКонтроль = ТаблицаОстатков.РезультатКонтроль;
	
	НеКонтролироватьОстатки = сабОбщегоНазначения.ПолучитьЗначениеСвойства(ПараметрыСеанса.ТекущийПользователь, "Разрешено проведение без контроля остатков");
	Если Не НеКонтролироватьОстатки = Истина Тогда
		Для каждого ТекСтрокаМинус Из РезультатКонтроль Цикл
			Отказ = Истина;
			Сообщить(?(ТекСтрокаМинус.УчетПоПодразделениям, "По Подразделению " + Строка(ТекСтрокаМинус.Подразделение) + " ", "") + "На Складе """ + Строка(ТекСтрокаМинус.Склад) + """ номенклатуры """ + Строка(ТекСтрокаМинус.Номенклатура) + " (" + Строка(ТекСтрокаМинус.Номенклатура.Код)  + ")"" из необходимых " + Строка(ТекСтрокаМинус.КоличествоНужно) + " присутствует только "  + Строка(ТекСтрокаМинус.КоличествоОстаток) );
		КонецЦикла;
	КонецЕсли;	
	
	Если ФлагВалюты Тогда
		КурсВалюты = Курс;
	Иначе
		КурсВалюты = 1
	КонецЕсли;
	
	Для Каждого ТекСтрокаТабличнаяЧасть Из Товары Цикл
		
		Движение = Движения.Учетный.Добавить();
		
		СчетКт = СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Номенклатура);
		
		Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
		Движение.Предприятия = Предприятие;
		Движение.Период = Дата;
		Движение.СчетКт = СчетКт;
		Если СчетКт.УчетПоПодразделениям Тогда
			Движение.ПодразделениеКт = Подразделение;
		КонецЕсли;
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 1, ТекСтрокаТабличнаяЧасть.Номенклатура);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 2, ТекСтрокаТабличнаяЧасть.Склад);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 3, ТекСтрокаТабличнаяЧасть.СерияНоменклатуры);
		Движение.СчетДт = СчетКонтрагента;
		
		Если Движение.СчетДт.Родитель = ПланыСчетов.Учетный.Счет79() Тогда
			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Предприятия", Истина)] = ПредприятиеВн;
			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Внутренние договоры", Истина)] = ПодразделениеВн;
			Если Движение.СчетДт.УчетПоПодразделениям Тогда
				Движение.ПодразделениеДт = Подразделение;
			КонецЕсли;
		Иначе	
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 1, Контрагент);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 2, Договор);
			Если Движение.СчетДт.УчетПоПодразделениям Тогда
				Движение.ПодразделениеДт = Подразделение;
			КонецЕсли;
		КонецЕсли;
		
		//++сабОпер
		Если НЕ Движение.СчетДт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Документ", Истина)) = Неопределено И РаспределятьПроводкиПоДокументамТоварооборота Тогда
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 3, Ссылка);
		КонецЕсли;
		//--сабОпер
		
		Если ФлагВалюты Тогда
			Движение.ВалютнаяСуммаДт = ТекСтрокаТабличнаяЧасть.Сумма; 
			Движение.ВалютаДт = Валюта;
		КонецЕсли;
		
		Движение.КоличествоКт = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.КоличествоПоПервичнымДокументам), ТекСтрокаТабличнаяЧасть.КоличествоПоПервичнымДокументам, ТекСтрокаТабличнаяЧасть.Количество);
		Движение.Сумма = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.СуммаПоПервичнымДокументам), ТекСтрокаТабличнаяЧасть.СуммаПоПервичнымДокументам, ТекСтрокаТабличнаяЧасть.Сумма) * КурсВалюты;
		
		//++саб опер
		//Если ЭтоКорректировка Тогда
		//	Движение.КоличествоДт = - Движение.КоличествоДт;
		//	Движение.Сумма = - Движение.Сумма;
		//КонецЕсли;
		//--
		
		СуммаПоЦене = Движение.Сумма;
		
		Движение.НомерСтрокиДок = ТекСтрокаТабличнаяЧасть.НомерСтроки;
		Движение.Содержание = Комментарий;
		
		//доводим остаток
		//Если НЕ Движение.Сумма = ВыборкаДетальныеЗаписи.Цена * ТекСтрокаТабличнаяЧасть.Количество Тогда
		
		ДвижениеСчетКТ = СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Номенклатура);
		
		УчетПоподразделениямСчетУчета = СоответствиеУчетаПоПодразделениям.Получить(СчетКт);
		Если УчетПоподразделениямСчетУчета Тогда
			СтруктураПоиска = Новый Структура("Номенклатура, Склад, Счет, Подразделение", ТекСтрокаТабличнаяЧасть.Номенклатура, ТекСтрокаТабличнаяЧасть.Склад, ДвижениеСчетКТ, Подразделение);
		Иначе	
			СтруктураПоиска = Новый Структура("Номенклатура, Склад, Счет", ТекСтрокаТабличнаяЧасть.Номенклатура, ТекСтрокаТабличнаяЧасть.Склад, ДвижениеСчетКТ);
		КонецЕсли;
		ВыборкаДетальныеЗаписи = РезультатОстатки.НайтиСтроки(СтруктураПоиска);
		
		Если ВыборкаДетальныеЗаписи.Количество() Тогда
			ДвижениеСумма = ВыборкаДетальныеЗаписи[0].Цена * ТекСтрокаТабличнаяЧасть.Количество - СуммаПоЦене;
			ДвижениеСодержание = "Корректировка до с/с " + Формат(ВыборкаДетальныеЗаписи[0].Цена, "ЧДЦ=2") ;
		Иначе
			ДвижениеСумма = 0 - СуммаПоЦене;
			ДвижениеСодержание = "Корректировка до с/с 0" ;
		КонецЕсли; 	
		
		Если ДвижениеСумма Тогда
			Движение = Движения.Учетный.Добавить();
			Движение.Период = Дата;
			Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
			Движение.Предприятия = Предприятие;
			Движение.СчетДт = ПланыСчетов.Учетный.Счет9002();
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,1,ТекСтрокаТабличнаяЧасть.Номенклатура);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,3,СтатьяФормальнаяСебестоимость);
			Если Движение.СчетДт.УчетПоПодразделениям Тогда
				Движение.ПодразделениеДт = Подразделение;
			КонецЕсли;
			Движение.СчетКт = ДвижениеСчетКТ;
			Если Движение.СчетКт.УчетПоПодразделениям Тогда
				Движение.ПодразделениеКт = Подразделение;
			КонецЕсли;	
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,1,ТекСтрокаТабличнаяЧасть.Номенклатура);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,2,ТекСтрокаТабличнаяЧасть.Склад);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,3,ТекСтрокаТабличнаяЧасть.СерияНоменклатуры);
			//Движение.КоличествоКт = ТекСтрокаТабличнаяЧасть.Количество;
			
			Движение.Сумма = ДвижениеСумма;
			Движение.Содержание = ДвижениеСодержание;
		КонецЕсли;
		
		
		Если ТекСтрокаТабличнаяЧасть.СуммаПоПервичнымДокументам <> 0 Тогда
			Если (ТекСтрокаТабличнаяЧасть.СуммаПоПервичнымДокументам - ТекСтрокаТабличнаяЧасть.Сумма) <> 0 Тогда
				Движение = Движения.Учетный.Добавить();
				Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
				Движение.Предприятия = Предприятие;
				Движение.Период = Дата;
				
				Движение.СчетКт = СчетКт;
				
				Если Движение.СчетКт.УчетПоПодразделениям Тогда
					Движение.ПодразделениеКт = Подразделение;
				КонецЕсли;
				
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 1, ТекСтрокаТабличнаяЧасть.Номенклатура);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 2, ТекСтрокаТабличнаяЧасть.Склад);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 3, ТекСтрокаТабличнаяЧасть.СерияНоменклатуры);
				
				Движение.КоличествоКт = ТекСтрокаТабличнаяЧасть.КоличествоПоПервичнымДокументам - ТекСтрокаТабличнаяЧасть.Количество;
				
				Движение.СчетДт = ПланыСчетов.Учетный.Счет7601();
				
				Если Движение.СчетДт.УчетПоПодразделениям Тогда
					Движение.ПодразделениеДт = Подразделение;
				КонецЕсли;
				
				КонтрНедостача = Справочники.Контрагенты.НайтиПоНаименованию("НЕДОСТАЧА", Истина);
				
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 1, КонтрНедостача);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 2, НайтиДоговорКонтрагента(КонтрНедостача, Номер));
				
				Движение.Сумма = (ТекСтрокаТабличнаяЧасть.СуммаПоПервичнымДокументам - ТекСтрокаТабличнаяЧасть.Сумма) * КурсВалюты;
				Движение.НомерСтрокиДок = ТекСтрокаТабличнаяЧасть.НомерСтроки;
				Движение.Содержание = "Недостача по документу " + СокрЛП(Ссылка);
			КонецЕсли;
		КонецЕсли;
		
		//возмещение транспорта
		Если ТекСтрокаТабличнаяЧасть.Доставка Тогда
			Движение = Движения.Учетный.Добавить();
			Движение.СчетДт = ПланыСчетов.Учетный.Счет9003();
			Движение.ПодразделениеДт = Подразделение;
			Движение.Период = Дата;
			Движение.Предприятия = Предприятие;
			Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
			Движение.Сумма = ТекСтрокаТабличнаяЧасть.СуммаДоставки * КурсВалюты;
			Если ФлагВалюты Тогда
				Движение.ВалютнаяСуммаКт = ТекСтрокаТабличнаяЧасть.СуммаДоставки; 
				Движение.ВалютаКт = Валюта;
			КонецЕсли;
			Движение.НомерСтрокиДок = ТекСтрокаТабличнаяЧасть.НомерСтроки;
			Движение.Содержание = "Затраты по доставке: " + Строка(Контрагент) + ", Кол-во:" + ТекСтрокаТабличнаяЧасть.Количество + " Доставка:" + ТекСтрокаТабличнаяЧасть.Доставка + ", " + Комментарий;
			
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 1, ТекСтрокаТабличнаяЧасть.Номенклатура);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 2, ТекСтрокаТабличнаяЧасть.Статья);
			
			Движение.СчетКт = СчетКонтрагента;
			
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 1, Контрагент);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 2, Договор);
			
			//++сабОпер
			Если НЕ Движение.СчетКт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Документ", Истина)) = Неопределено И РаспределятьПроводкиПоДокументамТоварооборота Тогда
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 3, Ссылка);
			КонецЕсли;
			//--сабОпер
			
			
			Если Движение.СчетКт.УчетПоПодразделениям Тогда
				Движение.ПодразделениеКт = Подразделение;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	МассивСторноДоговоров = Новый Массив;
	
	Для Каждого СтрокаУслуг Из Услуги Цикл
		Движение = Движения.Учетный.Добавить();
		Движение.Период = Дата;
		Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
		Движение.Предприятия = Предприятие;
		
		Движение.СчетДт = СтрокаУслуг.СчетЗатрат;
		Если Движение.СчетДт.УчетПоПодразделениям Тогда
			Движение.ПодразделениеДт = ?(ЗначениеЗаполнено(СтрокаУслуг.Подразделение), СтрокаУслуг.Подразделение, Подразделение);
		КонецЕсли;
		Если Движение.СчетДт.Количественный Тогда
			Движение.КоличествоДт = СтрокаУслуг.Количество;
		КонецЕсли;	
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,1,СтрокаУслуг.СтатьяЗатрат);
		Если Движение.СчетДт.ВидыСубконто.Количество() > 0 И Не ЗначениеЗаполнено(Движение.СубконтоДт[Движение.СчетДт.ВидыСубконто[0].ВидСубконто]) Тогда
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,1,СтрокаУслуг.Субконто1);
		КонецЕсли;
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,2,СтрокаУслуг.Субконто2);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,3,СтрокаУслуг.Субконто3);
		
		Движение.СчетКт = СчетКонтрагента;
		Если Движение.СчетКт.УчетПоПодразделениям Тогда
			Движение.ПодразделениеКт = Подразделение;
		КонецЕсли;
		Если СчетКонтрагента = ПланыСчетов.Учетный.Счет7902() ИЛИ СчетКонтрагента = ПланыСчетов.Учетный.Счет7901() Тогда
			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Предприятия", Истина)] = Контрагент;
			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Внутренние договоры", Истина)] = Договор;
		ИначеЕсли СчетКонтрагента = ПланыСчетов.Учетный.ВерхПоОплате Или СчетКонтрагента = ПланыСчетов.Учетный.Счет7601() Тогда
			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Контрагенты", Истина)] = Контрагент;
		ИначеЕсли СчетКонтрагента = ПланыСчетов.Учетный.ПоставщикиПрочие Тогда
			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Контрагенты", Истина)] = Контрагент;
			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Договоры", Истина)] = Договор;
			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Статьи затрат", Истина)] = СтрокаУслуг.Субконто3;
		Иначе	
			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Контрагенты", Истина)] = Контрагент;
			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Договоры", Истина)] = Договор;
		КонецЕсли;
		
		Если ФлагВалюты И Движение.СчетДт.Валютный Тогда
			Движение.ВалютнаяСуммаДт = СтрокаУслуг.Сумма; 
			Движение.ВалютаДт = Валюта;
		КонецЕсли;
		
		Если ФлагВалюты И Движение.СчетКт.Валютный Тогда
			Движение.ВалютнаяСуммаКт = СтрокаУслуг.Сумма; 
			Движение.ВалютаКт = Валюта;
		КонецЕсли;
		
		Движение.Сумма = СтрокаУслуг.Сумма * КурсВалюты;
		Движение.Содержание = СтрокаУслуг.Содержание;
	КонецЦикла;
	
	// Контроль отритцательных остатков
	//УЧ_Сервер.ПроверитьОтрицательныеОстатки(Ссылка,СоответствиеСчета,Отказ);
	
	//НеКонтролироватьОстаткиСвойство = ?(ДополнительныеСвойства.Свойство("НеКонтролироватьОтрицательныеОстатки"), ДополнительныеСвойства.НеКонтролироватьОтрицательныеОстатки, Ложь);
	//НеКонтролироватьОстатки = сабОбщегоНазначения.ПолучитьЗначениеСвойства(ПараметрыСеанса.ТекущийПользователь, "Разрешено проведение без контроля остатков");
	
	//временно закомментил
	//Если Не НеКонтролироватьОстатки = Истина И НЕ НеКонтролироватьОстаткиСвойство Тогда
	//	Для каждого ТекСтрокаМинус Из РезультатКонтроль Цикл
	//		Отказ = Истина;
	//		Сообщить(?(ТекСтрокаМинус.УчетПоПодразделениям, "По Подразделению " + Строка(ТекСтрокаМинус.Подразделение) + " ", "") + "На Складе """ + Строка(ТекСтрокаМинус.Склад) + """ номенклатуры """ + Строка(ТекСтрокаМинус.Номенклатура) + " (" + Строка(ТекСтрокаМинус.Номенклатура.Код)  + ")"" из необходимых " + Строка(ТекСтрокаМинус.КоличествоНужно) + " присутствует только "  + Строка(ТекСтрокаМинус.КоличествоОстаток) );
	//	КонецЦикла;
	//	Если Отказ Тогда
	//		ДополнительныеСвойства.Вставить("НехваткаОстатков", Истина);		
	//	КонецЕсли;
	//КонецЕсли;
	
	//оптимизация проведения. проверка на изменения проводок
	сабОперОбщегоНазначения.ПроверитьПроводкиНаИзменение(Движения.Учетный, ДополнительныеСвойства.КоличественныеПоказателиПроводокДляПроверки); 
	
	//меняем статус заказа
	Если НЕ Отказ И ЗначениеЗаполнено(ДокОснование) И ТипЗнч(ДокОснование) = Тип("ДокументСсылка.ЗаказПоставщику") И Не ДокОснование.Статус = Перечисления.СтатусыЗаказовПоставщикам.Закрыт Тогда		
		ЗаказОб = ДокОснование.ПолучитьОбъект();
		ЗаказОб.Статус = Перечисления.СтатусыЗаказовПоставщикам.Закрыт;
		ЗаказОб.Записать(РежимЗаписиДокумента.Запись);
	КонецЕсли;
	
	//добавление проводок на забалансовый ВОЗВ
	//ПроводкиНаЗабаланс(Движения.Учетный);
	сабОперОбщегоНазначения.РаспределитьПроводкиПоДокументамОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведенияДокумента);
	
КонецПроцедуры

Процедура ПроводкиНаЗабаланс(ДвиженияУчетный)
	
	
	ТаблицаРеквизитов = УправлениеСвойствами.ПолучитьЗначенияСвойств(Ссылка,,,ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Проводки на забаланс (вирт. возврат) (Возврат товаров поставщику)", Истина));
	СчетЗабаланс = ПланыСчетов.Учетный.НайтиПоКоду("ВОЗВ");
	НужныПроводкиЗабаланс = Ложь;
	Если ТаблицаРеквизитов.Количество() И ТаблицаРеквизитов[0].Значение Тогда
		НужныПроводкиЗабаланс = Истина;		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СчетЗабаланс) ИЛИ НЕ НужныПроводкиЗабаланс Тогда
		Возврат;
	КонецЕсли;
	КоллекцияДвижений = Новый ТаблицаЗначений;
	КоллекцияДвижений.Колонки.Добавить("Счет");
	КоллекцияДвижений.Колонки.Добавить("Номенклатура");
	КоллекцияДвижений.Колонки.Добавить("Количество");
	КоллекцияДвижений.Колонки.Добавить("Сумма");
	Для каждого ТекСтрока Из Движения.Учетный Цикл
		Если НЕ ТекСтрока.СубконтоКт.Количество() Тогда
			Продолжить;		
		КонецЕсли;
		НоваяСтрока = КоллекцияДвижений.Добавить();
		НоваяСтрока.Счет = ТекСтрока.СчетКт;
		Для каждого ТекСубконто Из ТекСтрока.СубконтоКт Цикл
			Если ТипЗнч(ТекСубконто.Значение) = Тип("СправочникСсылка.Номенклатура") Тогда
				НоваяСтрока.Номенклатура = ТекСубконто.Значение;
			КонецЕсли;
		КонецЦикла; 
		НоваяСтрока.Количество = ТекСтрока.КоличествоКт;
		НоваяСтрока.Сумма = ТекСтрока.Сумма;	
	КонецЦикла; 
	
	КоллекцияДвижений.Свернуть("Счет, Номенклатура", "Количество, Сумма");
	
	Для каждого ТекСтрока Из КоллекцияДвижений Цикл
		Движение = Движения.Учетный.Добавить();
		Движение.Период = Дата;
		Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
		Движение.Предприятия = Предприятие;
		
		Движение.СчетКт = СчетЗабаланс;
		Если Движение.СчетКт.УчетПоПодразделениям Тогда
			Движение.ПодразделениеКт = Подразделение;
		КонецЕсли;
		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Документ", Истина)] = Ссылка;
		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Номенклатура", Истина)] = ТекСтрока.Номенклатура;
		
		Движение.Сумма = ТекСтрока.Сумма;
		Движение.КоличествоКт = ТекСтрока.Количество;
	КонецЦикла; 
	
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	РучнаяКорректировка = Ложь;
	Движения.Записать();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого СтрокаУслуг Из Услуги Цикл
		Если Не ЗначениеЗаполнено(СтрокаУслуг.СчетЗатрат) Тогда
			Сообщить("В строке № " + СтрокаУслуг.НомерСтроки + " не установлен счет затрат");
			//Отказ = Истина;
		КонецЕсли;	
		Если ТипЗнч(СтрокаУслуг.СтатьяЗатрат) = Тип("СправочникСсылка.Субконто") Тогда
			Сообщить("В строке № " + СтрокаУслуг.НомерСтроки + " не обработана статья затрат");
			//Отказ = Истина;
		КонецЕсли;	
	КонецЦикла;
	
	//Если Константы.сабМодульОперативныйУчет.Получить() Тогда
	//	Если Предприятие.УчетПоПодразделениям Тогда
	//		ПроверяемыеРеквизиты.Добавить("Подразделение");			
	//	КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры

Функция НайтиДоговорКонтрагента(ТекКонтрагент, ТекНаименование)
	
	Если Не ЗначениеЗаполнено(ТекНаименование) Тогда
		ТекНаименование = "Основной";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоговорыКонтрагентов.Ссылка
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.Наименование = &Наименование
	|	И ДоговорыКонтрагентов.Владелец = &Владелец";
	Запрос.УстановитьПараметр("Наименование", ТекНаименование);
	Запрос.УстановитьПараметр("Владелец", ТекКонтрагент);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ТекДоговор = Справочники.ДоговорыКонтрагентов.СоздатьЭлемент();
		ТекДоговор.Наименование = ТекНаименование;
		ТекДоговор.Владелец = ТекКонтрагент;
		ТекДоговор.Записать();
		Возврат ТекДоговор.Ссылка;
	КонецЕсли;	
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.Ссылка;		
	КонецЦикла;	
	
КонецФункции

Функция НайтиВнутреннийДоговор(ТекПредприятие, ТекНаименование)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВнутренниеДоговоры.Ссылка
	|ИЗ
	|	Справочник.ВнутренниеДоговоры КАК ВнутренниеДоговоры
	|ГДЕ
	|	ВнутренниеДоговоры.Наименование = &Наименование
	|	И ВнутренниеДоговоры.Владелец = &Владелец";
	Запрос.УстановитьПараметр("Наименование", ТекНаименование);
	Запрос.УстановитьПараметр("Владелец", ТекПредприятие);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ТекДоговор = Справочники.ВнутренниеДоговоры.СоздатьЭлемент();
		ТекДоговор.Наименование = ТекНаименование;
		ТекДоговор.Владелец = ТекПредприятие;
		ТекДоговор.Предприятие = Предприятие;
		ТекДоговор.Записать();
		Возврат ТекДоговор.Ссылка;
	КонецЕсли;	
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.Ссылка;		
	КонецЦикла;	
	
КонецФункции

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	СуммаИтог = Товары.Итог("Сумма") + Услуги.Итог("Сумма");
	СуммаНДСИтог = Товары.Итог("СуммаНДС") + Услуги.Итог("СуммаНДС");
	СуммаДокумента = СуммаИтог;
	
	//Заполнить данные СФ по данным документа, если они не заполнены
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		//ДополнительныеСвойства.Вставить("Проведение", Истина);
		Если Не ЗначениеЗаполнено(ДатаСчетФактуры) Тогда
			ДатаСчетФактуры = Дата;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(НомерСчетФактуры) Тогда
			НомерСчетФактуры = Номер;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Склад) Тогда
		Для каждого ТекСтрока Из Товары Цикл
			ТекСтрока.Склад = Склад;
		КонецЦикла; 
	КонецЕсли; 
	
	
	//Обработка пометка удаления
	Если Не Ссылка.ПометкаУдаления И ПометкаУдаления Тогда	
		Запрос = новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	УЧ_ПеремещениеТоваров.Ссылка
		|ИЗ
		|	Документ.УЧ_ПеремещениеТоваров КАК УЧ_ПеремещениеТоваров
		|ГДЕ
		|	УЧ_ПеремещениеТоваров.ДокОснование = &ДокОснование
		|	И НЕ УЧ_ПеремещениеТоваров.ПометкаУдаления
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	УЧ_ВозвратТоваровПоставщику.Ссылка
		|ИЗ
		|	Документ.УЧ_ВозвратТоваровПоставщику КАК УЧ_ВозвратТоваровПоставщику
		|ГДЕ
		|	УЧ_ВозвратТоваровПоставщику.ДокОснование = &ДокОснование
		|	И НЕ УЧ_ВозвратТоваровПоставщику.ПометкаУдаления
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	УЧ_ПоступлениеТоваров.Ссылка
		|ИЗ
		|	Документ.УЧ_ПоступлениеТоваров КАК УЧ_ПоступлениеТоваров
		|ГДЕ
		|	УЧ_ПоступлениеТоваров.ДокОснование = &ДокОснование
		|	И НЕ УЧ_ПоступлениеТоваров.ПометкаУдаления";
		Запрос.УстановитьПараметр("ДокОснование", ДокОснование);
		Выгрузка = Запрос.Выполнить().Выгрузить();
		Если Выгрузка.Количество() = 1 Тогда //остался единственный не помеченный подчиненный заказу документ - этот
			Попытка
				Если ДокОснование.Статус = Перечисления.СтатусыЗаказовПоставщикам.Закрыт Тогда
					ЗаказОб = ДокОснование.ПолучитьОбъект();
					ЗаказОб.Статус = Перечисления.СтатусыЗаказовПоставщикам.Подтвержден;
					ЗаказОб.Записать(РежимЗаписиДокумента.Запись);
				КонецЕсли;
			Исключение
			КонецПопытки;
		КонецЕсли;		
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("КоличественныеПоказателиПроводокДляПроверки", сабОперОбщегоНазначения.ПолучитьКоличественныеПоказателиПроводок(Ссылка));	
	
	//из подписки на событие
	БюджетныйНаСервере.ДокументыПередЗаписьюПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтотОбъект.ЭтоНовый());
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПоставщику") Или ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УЧ_ПоступлениеТоваров") Тогда
		
		//Если НЕ ДанныеЗаполнения.ВидОперации = Перечисления.ВидыЗаказов.ВозвратБрака Тогда
		//	СтандартнаяОбработка = Ложь;
		//	Комментарий = "##НеверныйВидОперации" + ДанныеЗаполнения.ВидОперации;
		//	Возврат;
		//КонецЕсли; 
		
		Отказ = сабОперОбщегоНазначения.ПроверкаСозданияНаОснованииНаСервере(ДанныеЗаполнения, Комментарий, СтандартнаяОбработка, Тип("ДокументСсылка.УЧ_ВозвратТоваровПоставщику"));
		Если Отказ.Признак = "##УжеСоздан" Тогда
			ВызватьИсключение "На основании Заказ поставщику уже введен документ " + Отказ.Ссылка;
		ИначеЕсли Отказ.Признак = "##НеПроведен" Тогда
			ВызватьИсключение "Документ Заказ поставщику не проведен. Ввод на основании не возможен.";
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, , "Дата, Номер");
		СчетКонтрагента = ПланыСчетов.Учетный.Счет6001();
		ДокОснование = ДанныеЗаполнения;
		Для Каждого СтрокаТовары Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			СтрокаТЧ = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТЧ, СтрокаТовары);
		КонецЦикла;	
	КонецЕсли;
	
	сабОбщегоНазначенияБУХ.сабОбработкиЗаполненияУчпетныхДокументовОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	//Если ДополнительныеСвойства.Свойство("Проведение") Тогда
	//	Если Не ЗначениеЗаполнено(ДатаСчетФактуры) Тогда
	//		ДатаСчетФактуры = Дата;
	//	КонецЕсли;
	//	
	//	Если Не ЗначениеЗаполнено(НомерСчетФактуры) Тогда
	//		НомерСчетФактуры = Номер;
	//	КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры

Функция ПоучитьСоответствияСчетовНоменклатуры()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	УЧ_ВозвратТоваровПоставщикуТовары.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА УЧ_ВозвратТоваровПоставщикуТовары.Номенклатура.Счет10 = ЗНАЧЕНИЕ(ПланСчетов.Учетный.ПустаяСсылка)
	|			ТОГДА &Счет41
	|		ИНАЧЕ УЧ_ВозвратТоваровПоставщикуТовары.Номенклатура.Счет10
	|	КОНЕЦ КАК Счет
	|ИЗ
	|	Документ.УЧ_ВозвратТоваровПоставщику.Товары КАК УЧ_ВозвратТоваровПоставщикуТовары
	|ГДЕ
	|	УЧ_ВозвратТоваровПоставщикуТовары.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	УЧ_ВозвратТоваровПоставщикуТовары.Номенклатура,
	|	ВЫБОР
	|		КОГДА УЧ_ВозвратТоваровПоставщикуТовары.Номенклатура.Счет10 = ЗНАЧЕНИЕ(ПланСчетов.Учетный.ПустаяСсылка)
	|			ТОГДА &Счет41
	|		ИНАЧЕ УЧ_ВозвратТоваровПоставщикуТовары.Номенклатура.Счет10
	|	КОНЕЦ";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Счет10", ПланыСчетов.Учетный.Счет10());
	Запрос.УстановитьПараметр("Счет41", ПланыСчетов.Учетный.Счет41());
	Запрос.УстановитьПараметр("Счет43", ПланыСчетов.Учетный.Счет43());
	
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

Функция СчетаДляРаспределения() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Учетный.Ссылка КАК Ссылка
	|ИЗ
	|	ПланСчетов.Учетный КАК Учетный
	|ГДЕ
	|	Учетный.ВидыСубконто.ВидСубконто = &ВидСубконто
	|	И Учетный.ЗапретитьИспользоватьВПроводках = ЛОЖЬ
	|	И Учетный.Ссылка В(&Счета)";
	
	Запрос.УстановитьПараметр("Счета", СчетКонтрагента);
	Запрос.УстановитьПараметр("ВидСубконто", ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Документ", Истина));
	
	Результат = Запрос.Выполнить();
	Счета = Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Субконто1Массив = Новый Массив;
	Субконто2Массив = Новый Массив;
	Субконто1Массив.Добавить(Контрагент);
	Субконто2Массив.Добавить(Договор);
	
	Возврат Новый Структура("Субконто1Массив, Субконто2Массив, СчетаДляРаспределения, ЭтоСторно", Субконто1Массив, Субконто2Массив, Счета, Истина);
КонецФункции // ()

Процедура ПриКопировании(ОбъектКопирования)
	
	РучнаяКорректировка = Ложь;
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	БюджетныйНаСервере.ПриУстановкеНовогоНомераПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
КонецПроцедуры

Процедура ОбработкаЗаполненияСФормы(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт

	ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);	

КонецПроцедуры
