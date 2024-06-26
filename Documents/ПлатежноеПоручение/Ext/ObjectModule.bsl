﻿
&После("ОбработкаЗаполнения")
Процедура УУ_ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СоотвСтавокНДС = Новый Соответствие;
	СоотвСтавокНДС.Вставить(сабОбщегоНазначения.ПолучитьЭлементНДС("Без НДС"), Перечисления.СтавкиНДС.БезНДС);
	СоотвСтавокНДС.Вставить(сабОбщегоНазначения.ПолучитьЭлементНДС("10%"), Перечисления.СтавкиНДС.НДС10);
	СоотвСтавокНДС.Вставить(сабОбщегоНазначения.ПолучитьЭлементНДС("18%"), Перечисления.СтавкиНДС.НДС18);
	СоотвСтавокНДС.Вставить(сабОбщегоНазначения.ПолучитьЭлементНДС("20%"), Перечисления.СтавкиНДС.НДС20);
	СоотвСтавокНДС.Вставить(сабОбщегоНазначения.ПолучитьЭлементНДС("Пустая ссылка"), Перечисления.СтавкиНДС.БезНДС);
	
	СоотвВидовОпераций = Новый Соответствие;
	СоотвВидовОпераций.Вставить(Перечисления.ВидыОперацийПлатежноеПоручение.Оплата, Перечисления.ВидыОперацийСписаниеДенежныхСредств.ОплатаПоставщику);
	СоотвВидовОпераций.Вставить(Перечисления.ВидыОперацийПлатежноеПоручение.ПеречислениеНалога, Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеНалога);
	СоотвВидовОпераций.Вставить(Перечисления.ВидыОперацийПлатежноеПоручение.ПеречислениеСотруднику, Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеПодотчетномуЛицу);
	СоотвВидовОпераций.Вставить(Перечисления.ВидыОперацийПлатежноеПоручение.ОплатаВНХ, Перечисления.ВидыОперацийСписаниеДенежныхСредств.ОплатаПоставщику);
	СоотвВидовОпераций.Вставить(Перечисления.ВидыОперацийПлатежноеПоручение.СнятиеНаличных, Перечисления.ВидыОперацийСписаниеДенежныхСредств.СнятиеНаличных);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("НазначениеПлатежаБух") Тогда
		
		ДанныеЗаполнения.НазначениеПлатежа = ДанныеЗаполнения.НазначениеПлатежаБух;
		ДанныеЗаполнения.ВидОперации = СоотвВидовОпераций.Получить(ДанныеЗаполнения.ВидОперации);
		ВидПлатежа = "Электронно";
		
		ТекущаяСтрока =  ДанныеЗаполнения;
		
		Если ТекущаяСтрока.Свойство("УИДстроки") Тогда

			
			СтруктураОтбора = Новый Структура("УИДстроки", ТекущаяСтрока.УИДстроки);
			//МассивСтрок = ТекущаяСтрока.ЦФО.НайтиСтроки(СтруктураОтбора);
			
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ТекущаяСтрока);
			
			СтатусВКлиентБанке = Перечисления.СтатусыПлатежныхПорученийВКлиентБанке.Новый;
			ДоговорКонтрагента = ТекущаяСтрока.Договор;
			ИдентификаторПлатежа = ТекущаяСтрока.УИН;
			
			Если ТипЗнч(ТекущаяСтрока.Организация) = Тип("СправочникСсылка.Организации") Тогда
				Предприятие = ПП_Сервер.ПолучитьПредприятие(ТекущаяДата(),ТекущаяСтрока.БанковскийСчет);	
			КонецЕсли;
			
			//ФормаПлатежки.Объект.Предприятие = ТекущаяСтрока.Предприятие;
			//Если ЗначениеЗаполнено(ТекущаяСтрока.ДатаПлатежа) И ТекущаяСтрока.ДатаПлатежа < ТекущаяДата() Тогда
			Дата = ТекущаяДата();		
			//КонецЕсли;
			
			ПроцентОплаты = ?(ТекущаяСтрока.СуммаДокумента, ТекущаяСтрока.СуммаОплачено / ТекущаяСтрока.СуммаДокумента, 0);
			Если НЕ ПроцентОплаты Тогда
				ПроцентОплаты = 1;	
			КонецЕсли;
			
			СуммаДокумента = ТекущаяСтрока.СуммаДокумента - ТекущаяСтрока.СуммаОплачено;
			НазначениеПлатежа = ТекущаяСтрока.НазначениеПлатежаБух;
			Комментарий = ТекущаяСтрока.НазначениеПлатежа;
			УИДСтроки = ТекущаяСтрока.УИДстроки;
			//СтавкаНДС = БюджетныйНаСервере.ВернутьРеквизит(ТекущаяСтрока.СтавкаНДС, "Ставка");
			СтавкаНДС = СоотвСтавокНДС.Получить(ТекущаяСтрока.СтавкаНДС);
			БезНалогаНДС = ТекущаяСтрока.СтавкаНДС.НеОблагается ИЛИ  ТекущаяСтрока.СтавкаНДС = сабОбщегоНазначения.ПолучитьЭлементНДС("Без НДС");
			СтатьяДвиженияДенежныхСредств = ДанныеЗаполнения.СтатьяДДС;
			
			ОчищатьСтатьюДДСПриСозданииПлатежногоПоручения = Справочники.сабМониторВнедрения.ПолучитьЗначениеНастройки("ОчищатьСтатьюДДСПриСозданииПлатежногоПоручения");
			Если ОчищатьСтатьюДДСПриСозданииПлатежногоПоручения Тогда
				СтатьяДвиженияДенежныхСредств = Неопределено;	
			КонецЕсли;
			
			НазначениеПлат = НазначениеПлатежа;
			
			АвтоЗначенияРеквизитов = УчетДенежныхСредствБП.СформироватьАвтоЗначенияРеквизитовПлательщикаПолучателя(
			Организация, СчетОрганизации, Контрагент, СчетКонтрагента);
			
			Документы.ПлатежноеПоручение.СформироватьНазначениеПлатежа(
			ЭтотОбъект,
			АвтоЗначенияРеквизитов,
			Истина,
			Ложь);
			
			//СформироватьНазначениеПлатежа(ЭтотОбъект, НазначениеПлат, БезНалогаНДС, Истина);
			
			// КПП из {
			Если ЗначениеЗаполнено(ТекущаяСтрока.КПППлательщика) Тогда
				ФКПППлательщика = ТекущаяСтрока.КПППлательщика;
			Иначе
				КПППлательщика = БюджетныйНаСервере.ВернутьРеквизит(ТекущаяСтрока.Организация, "КПП");
			КонецЕсли;		
			//}
			
			Если НЕ ПустаяСтрока(ТекущаяСтрока.Организация) Тогда
				ИННПлательщика = БюджетныйНаСервере.ВернутьРеквизит(ТекущаяСтрока.Организация, "ИНН");	
				ТекстПлательщика = БюджетныйНаСервере.ВернутьРеквизит(ТекущаяСтрока.Организация, "НаименованиеПолное");
			КонецЕсли; 
			
			Если НЕ ПустаяСтрока(ТекущаяСтрока.Контрагент) Тогда
				Если ТипЗнч(ТекущаяСтрока.Контрагент) = Тип("СправочникСсылка.Сотрудники") Тогда
					ИННПолучателя = БюджетныйНаСервере.ВернутьРеквизиты(ТекущаяСтрока.Контрагент, "ФизическоеЛицо.ИНН").ФизическоеЛицоИНН;
					//КПППолучателя = БюджетныйНаСервере.ВернутьРеквизит(ТекущаяСтрока.Контрагент, "КПП");
					ТекстПолучателя = БюджетныйНаСервере.ВернутьРеквизит(ТекущаяСтрока.Контрагент, "Наименование");
				Иначе
					ИННПолучателя = БюджетныйНаСервере.ВернутьРеквизит(ТекущаяСтрока.Контрагент, "ИНН");
					КПППолучателя = БюджетныйНаСервере.ВернутьРеквизит(ТекущаяСтрока.Контрагент, "КПП");
					ТекстПолучателя = БюджетныйНаСервере.ВернутьРеквизит(ТекущаяСтрока.Контрагент, "НаименованиеПолное");
					Если НЕ ЗначениеЗаполнено(ТекстПолучателя) Тогда
						ТекстПолучателя = БюджетныйНаСервере.ВернутьРеквизит(ТекущаяСтрока.Контрагент, "Наименование");
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			Заявка = ТекущаяСтрока.Заявка;
			СозданОбработкой = Истина;
			
			СуммаВсего = 0;
			Если ТипЗнч(ТекущаяСтрока.Заявка) = Тип("ДокументСсылка.Д_ЗаявкаНаОплату") Тогда
				СтрокиЗаявки = ТекущаяСтрока.Заявка.ЗаявкаБезнал.НайтиСтроки(Новый Структура("УИДСтроки", УИДСтроки));
				Для каждого ТекСтрока Из СтрокиЗаявки Цикл
					СуммаВсего = СуммаВсего + ТекСтрока.СуммаДДС;
					Если ЗначениеЗаполнено(ТекСтрока.ЗаявкаНаФинансирование) Тогда
						Заявка = ТекСтрока.ЗаявкаНаФинансирование;
					КонецЕсли;
				КонецЦикла;
				
				СтрокиРасшифровки = ТекущаяСтрока.Заявка.РасшифровкиСтрок.НайтиСтроки(Новый Структура("УИДСтрокиЗаявки", УИДСтроки));
				Если НЕ СтрокиРасшифровки.Количество() Тогда
					Если ЗначениеЗаполнено(ТекСтрока.ЗаявкаНаФинансирование) Тогда
						НовыйДокШаблон = Документы.Д_ЗаявкаНаОплату.СоздатьДокумент();
						СтрокиРасшифровки = НовыйДокШаблон.РасшифровкиСтрок.Выгрузить();
						Если ТекСтрока.ЗаявкаНаФинансирование.РасшифровкаПлатежа Тогда
							Для каждого ТекСтрока Из ТекСтрока.ЗаявкаНаФинансирование.ТабличнаяЧасть Цикл
								НоваяСтрокаДока = СтрокиРасшифровки.Добавить();
								ЗаполнитьЗначенияСвойств(НоваяСтрокаДока, ТекСтрока);
								НоваяСтрокаДока.ЦФО = ТекСтрока.Предприятие;
								НоваяСтрокаДока.ВалютнаяСумма = ТекСтрока.ВалСумма;
								НоваяСтрокаДока.УИДСтрокиЗаявки = ТекСтрока.УИДСтроки;
							КонецЦикла; 
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
				МассивСтрок = Новый Массив;
				
				Для каждого ВыборкаПодробно Из СтрокиРасшифровки Цикл
					НоваяСтрока = ТабличнаяЧасть.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаПодробно);
					НоваяСтрока.Предприятие = ВыборкаПодробно.ЦФО;
					НоваяСтрока.Сумма = ВыборкаПодробно.Сумма * ?(СуммаВсего, СуммаДокумента / СуммаВсего, 0) * ПроцентОплаты;
					Если ТипЗнч(Заявка) = Тип("ДокументСсылка.Д_ЗаявкаНаФинансирование") Тогда
						СтрокиБюджета = Заявка.СтрокиГрафикаБюджета.НайтиСтроки(Новый Структура("УИДСтрокиРасшифровки, Использовать", УИДСтроки, Истина));
						Для каждого ТекСтрокаБюджета Из СтрокиБюджета Цикл
							НоваяСтрока.КлючАналитикиБюджета = Справочники.КлючиАналитикиБюджетов.НайтиПоРеквизиту("УИДСтроки", ТекСтрокаБюджета.УИДСтроки);
						КонецЦикла; 
					КонецЕсли;
				КонецЦикла;
			Иначе
				Заявка = ДанныеЗаполнения.ЗаявкаНаФинансирование;
			КонецЕсли;
			
			Если НЕ ТабличнаяЧасть.Количество() Тогда
				НоваяСтрока = ТабличнаяЧасть.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеЗаполнения);
				НоваяСтрока.Предприятие = ДанныеЗаполнения.ЦФО;
				НоваяСтрока.УИДСтрокиЗаявки = ДанныеЗаполнения.УИДстроки;
				НоваяСтрока.Сумма = ДанныеЗаполнения.СуммаДокумента - ДанныеЗаполнения.СуммаОплачено;
				//++пересчет суммы по курсу контрагента
				Если ЗначениеЗаполнено(ДанныеЗаполнения.ВалютаКонтрагента) И НЕ ДанныеЗаполнения.ВалютаКонтрагента = ДанныеЗаполнения.Валюта И НЕ ДанныеЗаполнения.ВалютаКонтрагента = УЧ_Сервер.НациональнаяВалюта() И Не ДанныеЗаполнения.СуммаОплачено И ДанныеЗаполнения.ВалютнаяСуммаКонтрагента Тогда
					КурсКонтрагента = УЧ_Сервер.ПолучитьКурсВалют(ДанныеЗаполнения.ВалютаКонтрагента,,, ТекущаяДата());
					НоваяСтрока.Сумма = КурсКонтрагента * ДанныеЗаполнения.ВалютнаяСуммаКонтрагента;
					Сообщить("Сумма по заявке " + Строка(Заявка) + " была пересчитана по текущему курсу. Было: " + Строка(СуммаДокумента) + ", стало: " + Строка(НоваяСтрока.Сумма) + ".");
					СуммаДокумента = НоваяСтрока.Сумма;
				КонецЕсли;
				//--
				Если ТипЗнч(Заявка) = Тип("ДокументСсылка.Д_ЗаявкаНаФинансирование") Тогда
					СтрокиБюджета = Заявка.СтрокиГрафикаБюджета.НайтиСтроки(Новый Структура("Использовать", Истина));
					Для каждого ТекСтрокаБюджета Из СтрокиБюджета Цикл
						НоваяСтрока.КлючАналитикиБюджета = Справочники.КлючиАналитикиБюджетов.НайтиПоРеквизиту("УИДСтроки", ТекСтрокаБюджета.УИДСтроки);
					КонецЦикла; 
				КонецЕсли;
			КонецЕсли;
			
			//ищем счет
			Если НЕ ПП_Сервер.ЭтоРасходнаяОперация(ВидОперации) И НЕ ЗначениеЗаполнено(ТекущаяСтрока.Заявка) Тогда
				Заявка = ПП_Сервер.ПодобратьСчетПоПлатежномуПоручению(ТекущаяСтрока.Контрагент, НазначениеПлатежа);
			КонецЕсли;
			ДанныеЗаполнения.НазначениеПлатежа = НазначениеПлатежа;

		КонецЕсли; 
	КонецЕсли; 
		
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Д_ЗаявкаНаФинансирование") Тогда
		
		Отказ = сабОперОбщегоНазначения.ПроверкаСозданияНаОснованииНаСервере(ДанныеЗаполнения, Комментарий, СтандартнаяОбработка, ТипЗнч(Ссылка));
		Если Отказ.Признак = "##УжеСоздан" Тогда
			ВызватьИсключение "На основании Заявка на оплату уже введен документ " + Отказ.Ссылка;
		ИначеЕсли Отказ.Признак = "##НеПроведен" Тогда
			ВызватьИсключение "Документ Заявка на оплату не проведен. Ввод на основании не возможен.";
		КонецЕсли;
		
		Заявка = ДанныеЗаполнения;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,"Номер");
		
		ВидОперации = СоотвВидовОпераций.Получить(ДанныеЗаполнения.ВидОперации);
		ВидПлатежа = "Электронно";
		СтатусВКлиентБанке = Перечисления.СтатусыПлатежныхПорученийВКлиентБанке.Новый;
		ИдентификаторПлатежа = ДанныеЗаполнения.УИН;
		
		СчетОрганизации = ДанныеЗаполнения.БанковскийСчет;
		
		СуммаДокмента = ДанныеЗаполнения.Сумма;
		СтавкаНДС = СоотвСтавокНДС.Получить(ДанныеЗаполнения.СтавкаНДС);
		БезНалогаНДС = ДанныеЗаполнения.СтавкаНДС.НеОблагается ИЛИ ДанныеЗаполнения.СтавкаНДС = сабОбщегоНазначения.ПолучитьЭлементНДС("Без НДС");
		
		// КПП из {
		Если ЗначениеЗаполнено(ДанныеЗаполнения.КПППлательщика) Тогда
			ФКПППлательщика = ДанныеЗаполнения.КПППлательщика;
		Иначе
			КПППлательщика = БюджетныйНаСервере.ВернутьРеквизит(ДанныеЗаполнения.Организация, "КПП");
		КонецЕсли;		
		//}
		
		Если НЕ ПустаяСтрока(ДанныеЗаполнения.Организация) Тогда
			ИННПлательщика = БюджетныйНаСервере.ВернутьРеквизит(ДанныеЗаполнения.Организация, "ИНН");	
			ТекстПлательщика = БюджетныйНаСервере.ВернутьРеквизит(ДанныеЗаполнения.Организация, "НаименованиеПолное");
		КонецЕсли; 
		
		Если НЕ ПустаяСтрока(ДанныеЗаполнения.Контрагент) Тогда
			ИННПолучателя = БюджетныйНаСервере.ВернутьРеквизит(ДанныеЗаполнения.Контрагент, "ИНН");
			КПППолучателя = БюджетныйНаСервере.ВернутьРеквизит(ДанныеЗаполнения.Контрагент, "КПП");
			Если ТипЗнч(ДанныеЗаполнения.Контрагент) = Тип("СправочникСсылка.Сотрудники") Тогда
				ТекстПолучателя = БюджетныйНаСервере.ВернутьРеквизит(ДанныеЗаполнения.Контрагент, "Наименование");
			Иначе
				ТекстПолучателя = БюджетныйНаСервере.ВернутьРеквизит(ДанныеЗаполнения.Контрагент, "НаименованиеПолное");
			КонецЕсли;
		КонецЕсли;
		
		СтатьяДвиженияДенежныхСредств = ДанныеЗаполнения.СтатьяДДС;
		
		Если ЗначениеЗаполнено(ДанныеЗаполнения.ВалютаКонтрагента) И НЕ ДанныеЗаполнения.ВалютаКонтрагента = ДанныеЗаполнения.Валюта И НЕ ДанныеЗаполнения.ВалютаКонтрагента = УЧ_Сервер.НациональнаяВалюта() И ДанныеЗаполнения.ВалютнаяСуммаКонтрагента И ДанныеЗаполнения.КурсКонтрагента Тогда
			КурсКонтрагента = УЧ_Сервер.ПолучитьКурсВалют(ДанныеЗаполнения.ВалютаКонтрагента,,, ТекущаяДата());	
			ТекСумма = ДанныеЗаполнения.ВалютнаяСуммаКонтрагента * КурсКонтрагента;
		Иначе
			ТекСумма = ДанныеЗаполнения.Сумма;
		КонецЕсли;
		
		Для каждого ТекСтрока Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			НоваяСтрока = ТабличнаяЧасть.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			Если Не ЗначениеЗаполнено(СтатьяДвиженияДенежныхСредств) Тогда
				СтатьяДвиженияДенежныхСредств = ТекСтрока.СтатьяДДС;			
			КонецЕсли;
			Если ДанныеЗаполнения.ТабличнаяЧасть.Количество() = 1 Тогда
				НоваяСтрока.Сумма = ТекСумма;
			КонецЕсли;
		КонецЦикла;
		
		ОчищатьСтатьюДДСПриСозданииПлатежногоПоручения = Справочники.сабМониторВнедрения.ПолучитьЗначениеНастройки("ОчищатьСтатьюДДСПриСозданииПлатежногоПоручения");
		Если ОчищатьСтатьюДДСПриСозданииПлатежногоПоручения Тогда
			СтатьяДвиженияДенежныхСредств = Неопределено;	
		КонецЕсли;
		
		Если НЕ ТабличнаяЧасть.Количество() Тогда
			НоваяСтрока = ТабличнаяЧасть.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеЗаполнения);
			НоваяСтрока.Предприятие = ДанныеЗаполнения.ЦФО;
			//НоваяСтрока.УИДСтрокиЗаявки = ДанныеЗаполнения.УИДстроки;
			НоваяСтрока.Сумма = ТекСумма;
		КонецЕсли;
		
		СуммаДокумента = ТекСумма;
		
		Если Не ЗначениеЗаполнено(Предприятие) Тогда
			Предприятие = ПП_Сервер.ПолучитьПредприятие(ДанныеЗаполнения.Дата, ДанныеЗаполнения.БанковскийСчет);//предприятие из счета
		КонецЕсли;
		
		АвтоЗначенияРеквизитов = УчетДенежныхСредствБП.СформироватьАвтоЗначенияРеквизитовПлательщикаПолучателя(
		Организация, СчетОрганизации, Контрагент, СчетКонтрагента);
		
		Документы.ПлатежноеПоручение.СформироватьНазначениеПлатежа(
		ЭтотОбъект,
		АвтоЗначенияРеквизитов,
		Истина,
		Ложь);
		
	КонецЕсли;
	
	//--саб

КонецПроцедуры

&После("ПриЗаписи")
Процедура УУ_ПриЗаписи(Отказ)
	сабОбщегоНазначения.сабПлатКалПриЗаписиОбъектовПриЗаписи(ЭтотОбъект, Отказ);
КонецПроцедуры

&После("ПриКопировании")
Процедура УУ_ПриКопировании(ОбъектКопирования)
	СтрокиЗаявкиНаОплату.Очистить();
	Заявка = Неопределено;
	Акцептован = Ложь;
	УИН = Неопределено;
	УИДСтроки = Неопределено;
	СтатусВКлиентБанке = Перечисления.СтатусыПлатежныхПорученийВКлиентБанке.Новый;
	Для каждого ТекСтрока Из ТабличнаяЧасть Цикл
		ТекСтрока.УИДСтрокиЗаявки = Неопределено;
		ТекСтрока.КлючАналитикиБюджета = Неопределено;
	КонецЦикла;
КонецПроцедуры

&После("ПередЗаписью")
Процедура УУ_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Не ЗначениеЗаполнено(СтатусВКлиентБанке) Тогда
		СтатусВКлиентБанке = Перечисления.СтатусыПлатежныхПорученийВКлиентБанке.Новый;
	КонецЕсли;
КонецПроцедуры
