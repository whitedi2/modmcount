﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Если РучнаяКорректировка Тогда		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Движения документа %1 отредактированы вручную и не могут быть автоматически актуализированы'"), ЭтотОбъект);
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ТекстСообщения;
		Сообщение.КлючДанных = Ссылка;
		Сообщение.Сообщить();		
		
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// Контроль отритцательных остатков
	//УЧ_Сервер.ПроверитьОтрицательныеОстатки(Ссылка,СоответствиеСчета,Отказ);
	НеКонтролироватьОстаткиСвойство = ?(ДополнительныеСвойства.Свойство("НеКонтролироватьОтрицательныеОстатки"), ДополнительныеСвойства.НеКонтролироватьОтрицательныеОстатки, Ложь);
	НеКонтролироватьОстатки = сабОбщегоНазначения.ПолучитьЗначениеСвойства(ПараметрыСеанса.ТекущийПользователь, "Разрешено проведение без контроля остатков");
	
	Если (НеКонтролироватьОстатки <> Истина) И НЕ НеКонтролироватьОстаткиСвойство И ДополнительныеСвойства.Свойство("РезультатКонтроль") Тогда
		
		Для каждого ТекСтрокаМинус Из ДополнительныеСвойства.РезультатКонтроль Цикл
			Отказ = Истина;
			Сообщить(?(ТекСтрокаМинус.УчетПоПодразделениям, "По Подразделению " + Строка(ТекСтрокаМинус.Подразделение) + " ", "") + "На Складе """ + Строка(ТекСтрокаМинус.Склад) + """ номенклатуры """ + Строка(ТекСтрокаМинус.Номенклатура) + " (" + Строка(ТекСтрокаМинус.Номенклатура.Код)  + ")"" из необходимых " + Строка(ТекСтрокаМинус.КоличествоНужно) + " присутствует только "  + Строка(ТекСтрокаМинус.КоличествоОстаток) );
		КонецЦикла;
		
		Если Отказ Тогда
			ДополнительныеСвойства.Вставить("НехваткаОстатков", Истина);		
		КонецЕсли;
		
	КонецЕсли;//конец контроля остатков
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ДатаДокументаИзменена") Тогда
		Движения.Учетный.Записать();	
	КонецЕсли;
	
	СоответствиеСчета = ДополнительныеСвойства.СоответствиеСчета;
	СоответствиеУчетаПоПодразделениям = ДополнительныеСвойства.СоответствиеУчетаПоПодразделениям;
	
	СчетЗабаланса = ПланыСчетов.Учетный.Счет002();
		
	Движения.Учетный.Записывать = Истина;
	
	Для Каждого ТекСтрокаТабличнаяЧасть Из ТабличнаяЧасть Цикл
		//Если УЧ_Сервер.НеЗаполненностьКоличестваИЦеныВТЧДок(ТекСтрокаТабличнаяЧасть) = Истина Тогда //проверка на заполненность кол-ва или цены
		//	
		//	Отказ = Истина;
		//	Сообщить("У документа "+ ЭтотОбъект + ", в строке №"+ТекСтрокаТабличнаяЧасть.НомерСтроки+" не заполнено количество и цена.");
		//КонецЕсли;    			
		Движение = Движения.Учетный.Добавить();
		Движение.Период = Дата;
		Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
		Движение.Предприятия = Предприятие;
		
		Движение.СчетКт = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.СчетУчета), ТекСтрокаТабличнаяЧасть.СчетУчета, СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Номенклатура));
		УчетПоподразделениямСчетУчета = СоответствиеУчетаПоПодразделениям.Получить(Движение.СчетКт);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,1,ТекСтрокаТабличнаяЧасть.Номенклатура);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,2,ТекСтрокаТабличнаяЧасть.Склад);
		
		Если УчетПоподразделениямСчетУчета Тогда
			Движение.ПодразделениеКт = Подразделение;
		КонецЕсли;
		
		Движение.СчетДт = ТекСтрокаТабличнаяЧасть.КорСчет;
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекСтрокаТабличнаяЧасть.КорСчет,1,ТекСтрокаТабличнаяЧасть.КорСубконто1);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекСтрокаТабличнаяЧасть.КорСчет,2,ТекСтрокаТабличнаяЧасть.КорСубконто2);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекСтрокаТабличнаяЧасть.КорСчет,3,ТекСтрокаТабличнаяЧасть.КорСубконто3);
		
		Если Движение.СчетДт.УчетПоПодразделениям Тогда
			Движение.ПодразделениеДт = ТекСтрокаТабличнаяЧасть.КорПодразделение;
		КонецЕсли;
		
		Если Движение.СчетДт.Количественный Тогда
			Движение.КоличествоДт = ТекСтрокаТабличнаяЧасть.Количество;
		КонецЕсли;
		
		Движение.КоличествоКт = ТекСтрокаТабличнаяЧасть.Количество;
		Движение.Сумма = ТекСтрокаТабличнаяЧасть.Сумма;
		Движение.Содержание = Комментарий;
		
		Если ОтражатьЗаБалансом Тогда //д1 26.09.18
			Движение = Движения.Учетный.Добавить();
			Движение.Период = Дата;
			Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
			Движение.Предприятия = Предприятие;
			
			Движение.СчетДт = СчетЗабаланса;
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,СчетЗабаланса,1,ТекСтрокаТабличнаяЧасть.Номенклатура);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,СчетЗабаланса,2,ТекСтрокаТабличнаяЧасть.Склад);
			//УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ТекСтрокаТабличнаяЧасть.СчетЗатрат,3,ТекСтрокаТабличнаяЧасть.Субконто3);
			
			Если Движение.СчетДт.УчетПоПодразделениям Тогда
				Движение.ПодразделениеДт = ТекСтрокаТабличнаяЧасть.КорПодразделение;
			КонецЕсли;
			
			Если Движение.СчетДт.Количественный Тогда
				Движение.КоличествоДт = ТекСтрокаТабличнаяЧасть.Количество;
			КонецЕсли;
			
			Движение.Сумма = ТекСтрокаТабличнаяЧасть.Сумма;
			Движение.Содержание = "Отражение за балансом";		
		КонецЕсли;
		
	КонецЦикла;
	
	//оптимизация проведения. проверка на изменения проводок
	//сабОперОбщегоНазначения.ПроверитьПроводкиНаИзменение(Движения.Учетный, ДополнительныеСвойства.КоличественныеПоказателиПроводокДляПроверки);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Для Каждого ТекСтрокаТабличнаяЧасть Из ТабличнаяЧасть Цикл
		ТекСтрокаТабличнаяЧасть.Сумма = 0;
	КонецЦикла;
	РучнаяКорректировка = Ложь;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование = "";
	РучнаяКорректировка = Ложь;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураИмен = УЧ_Сервер.СформироватьСтруктуруИмен(ЭтотОбъект);
	
	СтруктураСоответствий = УЧ_Сервер.ПоучитьСоответствияСчетовНоменклатуры(ЭтотОбъект, СтруктураИмен);
	СоответствиеСчета = СтруктураСоответствий.Соответствия;
	СоответствиеУчетаПоПодразделениям = СтруктураСоответствий.СоответствияУчетаПодразделений;
	ДополнительныеСвойства.Вставить("СоответствиеСчета", СоответствиеСчета);
	ДополнительныеСвойства.Вставить("СоответствиеУчетаПоПодразделениям", СоответствиеУчетаПоПодразделениям);
	
	ТаблицаОстатков = УЧ_Сервер.ПолучитьТаблицуОстатков(ЭтотОбъект, СтруктураИмен, СтруктураСоответствий);
	РезультатОстатки = ТаблицаОстатков.РезультатОстатки;
	РезультатКонтроль = ТаблицаОстатков.РезультатКонтроль;
	
	Для Каждого ТекСтрокаТабличнаяЧасть Из ТабличнаяЧасть Цикл
		СчетКт = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.СчетУчета), ТекСтрокаТабличнаяЧасть.СчетУчета, СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Номенклатура));
		УчетПоподразделениямСчетУчета = СоответствиеУчетаПоПодразделениям.Получить(СчетКт);
		
		Если УчетПоподразделениямСчетУчета Тогда
			СтруктураПоиска = Новый Структура("Номенклатура, Склад, Счет, Подразделение", ТекСтрокаТабличнаяЧасть.Номенклатура, ТекСтрокаТабличнаяЧасть.Склад, СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Номенклатура), Подразделение);
		Иначе	
			СтруктураПоиска = Новый Структура("Номенклатура, Склад, Счет", ТекСтрокаТабличнаяЧасть.Номенклатура, Склад, СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Номенклатура));
		КонецЕсли;
		ВыборкаДетальныеЗаписи = РезультатОстатки.НайтиСтроки(СтруктураПоиска);
		Если ТекСтрокаТабличнаяЧасть.Количество <> 0 Тогда
			Если ВыборкаДетальныеЗаписи.Количество() Тогда
				Если ТекСтрокаТабличнаяЧасть.Количество = ВыборкаДетальныеЗаписи[0].Количество Тогда
					ТекСтрокаТабличнаяЧасть.Цена = ВыборкаДетальныеЗаписи[0].Цена;
					ТекСтрокаТабличнаяЧасть.Сумма = ВыборкаДетальныеЗаписи[0].Сумма;
				Иначе	
					ТекСтрокаТабличнаяЧасть.Цена = ВыборкаДетальныеЗаписи[0].Цена;
					ТекСтрокаТабличнаяЧасть.Сумма = ВыборкаДетальныеЗаписи[0].Цена * ТекСтрокаТабличнаяЧасть.Количество;
				КонецЕсли;
			Иначе
				ТекСтрокаТабличнаяЧасть.Цена = 0;
				ТекСтрокаТабличнаяЧасть.Сумма = 0;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	ДополнительныеСвойства.Вставить("РезультатКонтроль", РезультатКонтроль);
	УстановитьПривилегированныйРежим(Ложь);
	
	СуммаДокумента = ТабличнаяЧасть.Итог("Сумма");
	
	//дата изменена
	Если ЗначениеЗаполнено(Ссылка) И НЕ Дата = Ссылка.Дата Тогда
		ДополнительныеСвойства.Вставить("ДатаДокументаИзменена", Истина);		
	КонецЕсли;
	
	//из подписки на событие
	БюджетныйНаСервере.ДокументыПередЗаписьюПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	БюджетныйНаСервере.ПриУстановкеНовогоНомераПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УЧ_ПоступлениеТоваров") Тогда
		
		Отказ = сабОперОбщегоНазначения.ПроверкаСозданияНаОснованииНаСервере(ДанныеЗаполнения, Комментарий, СтандартнаяОбработка);
		Если Отказ.Признак = "##УжеСоздан" Тогда
			ВызватьИсключение "На основании Поступление ТМЦ и услуг (упр) уже введен документ " + Отказ.Ссылка;
		ИначеЕсли Отказ.Признак = "##НеПроведен" Тогда
			ВызватьИсключение "Документ Поступление ТМЦ и услуг (упр) не проведен. Ввод на основании не возможен.";
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, , "Дата, Номер");
		ДокументОснование = ДанныеЗаполнения;
		Для Каждого СтрокаТовары Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			СтрокаТЧ = ТабличнаяЧасть.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТЧ, СтрокаТовары);
		КонецЦикла;
		
	КонецЕсли;
	
	сабОбщегоНазначенияБУХ.сабОбработкиЗаполненияУчпетныхДокументовОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбработкаЗаполненияСФормы(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт

	ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);	

КонецПроцедуры
